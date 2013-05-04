-module(qtcp_session).

-behaviour(gen_server).

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {lsock, queue}).

start_link(LSock) ->
    gen_server:start_link(?MODULE, [LSock], []).

init([LSock]) ->
    Queue = qtcp_queue:new(),
    {ok, #state{lsock = LSock, queue = Queue}, 0}.

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
    
    SessionId = State#state.queue,

    try

        io:format("~p request ~p ~n", [SessionId, RawData]),

        Status = case qtcp_protocol:parse_request(RawData) of
            {enqueue, Payload} -> 
                qtcp_queue:enqueue(SessionId, Payload),
                ok;
            dequeue -> 
                qtcp_queue:dequeue(SessionId);
            error -> 
                bad_request
        end,
        
        io:format("~p response ~p ~n", [SessionId, Status]),

        gen_tcp:send(Socket, io_lib:fwrite("~p~n", [Status]))
    catch
        Err ->
            io:format("~p error ~p ~n", [SessionId, Err]),
            gen_tcp:send(Socket, io_lib:fwrite("ERROR  ~p ~n", [Err]))
    end,
    State.