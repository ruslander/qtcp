-module(qtcp_queue_coordinator_tests).
-include_lib("eunit/include/eunit.hrl").

new_will_make_an_instance_of_queue_test() ->
  ?assertEqual({queue,[]}, qtcp_queue_coordinator:new()).



enqueue_will_append_an_element_to_the_queue_test() ->
  ?assertEqual({queue, [1]}, qtcp_queue_coordinator:enqueue({queue,[]}, 1)).

enqueue_will_add_an_element_to_existing_item_set_of_the_queue_test() ->
  ?assertEqual({queue, [4,3,2,1]}, qtcp_queue_coordinator:enqueue({queue,[3,2,1]}, 4)).

enqueue_3_consecutive_operations_test() ->
  ?assertEqual({queue, [1]}, qtcp_queue_coordinator:enqueue({queue,[]}, 1)),
  ?assertEqual({queue, [2, 1]}, qtcp_queue_coordinator:enqueue({queue,[1]}, 2)),
  ?assertEqual({queue, [3, 2, 1]}, qtcp_queue_coordinator:enqueue({queue,[2, 1]}, 3)).


dequeue_will_remove_the_first_element_in_the_queue_test() ->
  ?assertEqual({1, {queue, [3,2]}}, qtcp_queue_coordinator:dequeue({queue, [3,2,1]})).

dequeue_3_consecutive_operations_test() ->
  ?assertEqual({1, {queue, [3,2]}}, qtcp_queue_coordinator:dequeue({queue, [3,2,1]})),
  ?assertEqual({2, {queue, [3]}}, qtcp_queue_coordinator:dequeue({queue, [3,2]})),
  ?assertEqual({3, {queue, []}}, qtcp_queue_coordinator:dequeue({queue, [3]}))
  .

dequeue_will_error_on_an_mpty_queue_test() ->
  ?assertEqual({empty_queue, {queue, []}}, qtcp_queue_coordinator:dequeue({queue, []})).
