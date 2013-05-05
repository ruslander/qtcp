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


two_connections_test() ->

	{ok, Sock1} = gen_tcp:connect("localhost", 9000, [list, {packet, 0}]),
	{ok, Sock2} = gen_tcp:connect("localhost", 9000, [list, {packet, 0}]),
	
	send(Sock1, "in one"),
	send(Sock1, "in two"),
	send(Sock2, "in three"),

	R1 = send(Sock1, "out"),
	R2 = send(Sock1, "out"),
	R3 = send(Sock2, "out"),

	gen_tcp:close(Sock1),
	gen_tcp:close(Sock2),
	
	?assertEqual("\"one\"\n", R1),
	?assertEqual("\"two\"\n", R2),
	?assertEqual("\"three\"\n", R3).

bad_request_test() ->
	R1 = send("ttt"),
	?assertEqual("bad_request\n", R1).

empty_queue_test() ->
	R1 = send("out"),
	?assertEqual("empty_queue\n", R1).

send(Message) ->
	{ok, Sock1} = gen_tcp:connect("localhost", 9000, [list, {packet, 0}]),
 	R1 = send(Sock1, Message),
	gen_tcp:close(Sock1),
	R1.

send(Sock, Message) ->
	gen_tcp:send(Sock, Message),

	receive
        {tcp,Sock,String} -> String
        after 1000 -> timeout        
    end.
