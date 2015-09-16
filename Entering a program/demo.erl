-module(demo).
-export([double/1]).

double(Num) when is_number(Num) ->
    Num * 2.
