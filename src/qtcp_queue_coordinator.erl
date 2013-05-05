-module(qtcp_queue_coordinator).

-export([new/0, enqueue/2, dequeue/1]).

new() -> {queue, []}.

enqueue({queue, Content}, Item) -> {queue, [Item|Content]}.

dequeue({queue, []}) -> {empty_queue, []};
dequeue({queue, Content}) -> 
	[Head|Tile] = lists:reverse(Content),
	{Head, {queue, lists:reverse(Tile)}}.
