-module(qtcp_queue_tests).
-include_lib("eunit/include/eunit.hrl").

enque_ref_deque_api_test() ->
  	Name = qtcp_queue:new(),
  	qtcp_queue:enqueue(Name, a),
  	qtcp_queue:enqueue(Name, b),
  	?assertEqual(a, qtcp_queue:dequeue(Name)).

enque_ref_2_deque_api_test() ->
  	
  	Name1 = qtcp_queue:new(),
  	qtcp_queue:enqueue(Name1, a),
  	qtcp_queue:enqueue(Name1, c),

  	Name2 = qtcp_queue:new(),
  	qtcp_queue:enqueue(Name2, b),
  	
  	?assertEqual(a, qtcp_queue:dequeue(Name1)),
 	?assertEqual(b, qtcp_queue:dequeue(Name2)),
  	?assertEqual(c, qtcp_queue:dequeue(Name1))
  	.
