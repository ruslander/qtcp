-module(qtcp_protocol).

-export([parse_request/1,parse_enqueue_request/1, parse_dequeue_request/1]).

parse_request(Request) ->

	Cmd = trim_whitespace(Request),
	CmdLen = string:len(Cmd),

	case string:substr(Cmd, 1,3) of
	    "in " -> parse_enqueue_request(Cmd);
	    "out" when CmdLen == 3 -> parse_dequeue_request(Cmd);
	    _ -> error
	end.

parse_enqueue_request(Request) ->
	Payload = lists:subtract(Request, "in "),
	{enqueue, Payload}.

parse_dequeue_request(Request) ->
	"out" = string:strip(Request),
	dequeue.

trim_whitespace(A) -> 
	re:replace(A, "(^\\s+)|(\\s+$)", "", [global,{return,list}]).