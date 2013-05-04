-module(qtcp_acceptance_tests).
-include_lib("eunit/include/eunit.hrl").

one_connection_test() ->

	{ok, Sock} = gen_tcp:connect("localhost", 9000, [list, {packet, 0}]),
	
	send(Sock, "in one"),
	send(Sock, "in two"),
	send(Sock, "in three"),

	R1 = send(Sock, "out"),
	R2 = send(Sock, "out"),
	R3 = send(Sock, "out"),

    gen_tcp:close(Sock),
	
	?assertEqual("\"one\"\n", R1),
	?assertEqual("\"two\"\n", R2),
	?assertEqual("\"three\"\n", R3).


send(Sock, Message) ->
	gen_tcp:send(Sock, Message),

	receive
        {tcp,Sock,String} -> String
        after 1000 -> timeout        
    end.
