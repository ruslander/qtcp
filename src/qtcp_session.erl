-module(qtcp_session).

-behaviour(gen_server).

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {lsock}).

start_link(LSock) ->
    gen_server:start_link(?MODULE, [LSock], []).

init([LSock]) ->
    qtcp_queue:new(),
    {ok, #state{lsock = LSock}, 0}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_info({tcp, Socket, RawData}, State) ->
    NewState = handle_data(Socket, RawData, State),
    {noreply, NewState};
handle_info({tcp_closed, _Socket}, State) ->
    {stop, normal, State};
handle_info(timeout, #state{lsock = LSock} = State) ->
	io:format("waiting for conections ...~n"),
    {ok, _Sock} = gen_tcp:accept(LSock),
    qtcp_sup:start_child(),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Internal functions
handle_data(Socket, RawData, State) ->
    try

        io:format("request ~p ~n", [RawData]),

        Status = case qtcp_protocol:parse_request(RawData) of
            {enqueue, Payload} -> 
                qtcp_queue:enqueue(Payload),
                ok;
            dequeue -> 
                qtcp_queue:dequeue();
            error -> 
                bad_request
        end,
        
        io:format("response ~p ~n", [Status]),

        gen_tcp:send(Socket, io_lib:fwrite("~p~n", [Status]))
    catch
        _Class:Err ->
            gen_tcp:send(Socket, io_lib:fwrite("ERROR  ~p ~n", [Err]))
    end,
    State.