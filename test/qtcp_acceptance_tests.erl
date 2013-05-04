-module(qtcp_acceptance_tests).
-include_lib("eunit/include/eunit.hrl").

one_connection_test() ->
	%ok = application:start(qtcp),

	{ok, Sock} = gen_tcp:connect("localhost", 9000, [list, {packet, 0}]),
	
	send(Sock, "in one"),
	%gen_tcp:send(Sock, <<"in two\r\n">>),
	%gen_tcp:send(Sock, <<"in three\r\n">>),

	Result = send(Sock, "out"),

    gen_tcp:close(Sock),
	
	%application:stop(qtcp),
	
	?assertEqual("\"one\"\n", Result).


send(Sock, Message) ->
	gen_tcp:send(Sock, Message),

	receive
        {tcp,Sock,String} -> String
        after 1000 -> timeout        
    end.
