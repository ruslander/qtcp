-module(qtcp_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(PORT, 9000).

start(_StartType, _StartArgs) ->
    {ok, LSock} = gen_tcp:listen(?PORT, [{active, true}]),
    case qtcp_sup:start_link(LSock) of
        {ok, Pid} ->
            qtcp_sup:start_child(),
            {ok, Pid};
        Other ->
            {error, Other}
    end.

stop(_State) ->
    ok.