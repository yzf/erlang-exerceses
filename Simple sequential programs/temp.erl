-module(temp).
-export([f2c/1, c2f/1, convert/1]).

f2c(F) when is_number(F) ->
    (F - 32) * 5 / 9.

c2f(C) when is_number(C) ->
    C * 9 / 5 + 32.

convert({c, C}) when is_number(C) ->
    {f, c2f(C)};
convert({f, F}) when is_number(F) ->
    {c, f2c(F)}.
