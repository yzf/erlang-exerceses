-module(lists1).
-compile({no_auto_import, [min/2, max/2]}).
-export([min/1, max/1, min_max/1]).

min([H | T] = L) when length(L) > 0 ->
    min(H, T).

min(Min, []) ->
    Min;
min(Min, [H | T]) when Min < H ->
    min(Min, T);
min(_Min, [H | T]) ->
    min(H, T).


max([H | T] = L) when length(L) > 0 ->
    max(H, T).

max(Max, []) ->
    Max;
max(Max, [H | T]) when Max > H ->
    max(Max, T);
max(_Max, [H | T]) ->
    max(H, T).

min_max(L) when length(L) > 0 ->
    {min(L), max(L)}.
