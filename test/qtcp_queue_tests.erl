-module(qtcp_queue_tests).
-include_lib("eunit/include/eunit.hrl").

enque_deque_api_test() ->
  qtcp_queue:new(),
  qtcp_queue:enqueue(a),
  qtcp_queue:enqueue(b),
  ?assertEqual(a, qtcp_queue:dequeue()).

