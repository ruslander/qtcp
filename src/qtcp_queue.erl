-module(qtcp_queue).
-behaviour(gen_server).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1, inspect/1, enqueue/2, dequeue/1, new/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------


start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [], []).

new() ->
    Name = list_to_atom(erlang:ref_to_list(make_ref())),
    start_link(Name),
    Name.

inspect(Name) ->
    gen_server:cast(Name, {inspect}).

enqueue(Name, Item) ->
    gen_server:cast(Name, {enqueue, Item}).

dequeue(Name) ->
    gen_server:call(Name, {dequeue}).


%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(_) ->
	Queue = qtcp_queue_coordinator:new(),
    {ok, Queue}.


handle_call({dequeue}, _From, Queue) ->
	io:format("dequeueing ... ~p~n",[Queue]),
	{Item, DequeuedQueue} =	qtcp_queue_coordinator:dequeue(Queue),
    {reply, Item, DequeuedQueue};
handle_call(_Request, _From, Queue) ->
    {reply, ok, Queue}.


handle_cast({inspect}, Queue) ->
	io:format("inspecting ... ~p~n",[Queue]),
	{noreply, Queue};

handle_cast({enqueue, Item}, Queue) ->
	io:format("enqueuing ~p to ... ~p~n",[Item,Queue]),
	AppendedQueue = qtcp_queue_coordinator:enqueue(Queue, Item),
	{noreply, AppendedQueue};


handle_cast(_Msg, Queue) ->
    {noreply, Queue}.

handle_info(_Info, Queue) ->
    {noreply, Queue}.

terminate(_Reason, _Queue) ->
    ok.

code_change(_OldVsn, Queue, _Extra) ->
    {ok, Queue}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

