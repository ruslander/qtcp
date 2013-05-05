-module(qtcp_protocol_tests).
-include_lib("eunit/include/eunit.hrl").

detect_malformed_command_test() ->
	?assertEqual(error, qtcp_protocol:parse_request("int {}")).

detect_malformed_command2_test() ->
	?assertEqual(error, qtcp_protocol:parse_request("outt")).


detect_enqueue_command_and_parse_test() ->
	?assertEqual({enqueue, "{}"}, qtcp_protocol:parse_request("in {}")).

detect_dequeue_command_and_parse_test() ->
	?assertEqual(dequeue, qtcp_protocol:parse_request("out")).

enque_parsing_test() ->
  	Cmd = qtcp_protocol:parse_enqueue_request("in {the:payload which protocol does not care}"),
  	?assertEqual({enqueue, "{the:payload which protocol does not care}"}, Cmd).

dequeue_parsing_test() ->
  	Cmd = qtcp_protocol:parse_dequeue_request(" out "),
  	?assertEqual(dequeue, Cmd).
