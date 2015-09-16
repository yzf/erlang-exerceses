-module(processes2).
-export([start/3, build_processes/1, loop/2]).

start(N, M, Message) ->
    LastPid = build_processes(N),
    LastPid ! {Message, M},
    loop(LastPid, true),
    ok.

build_processes(N) ->
    lists:foldl(
        fun(_Num, Pid) ->
        spawn(?MODULE, loop, [Pid, false]) end,
        self(),
        lists:seq(1, N)).

loop(NextPid, IsLast) ->
    receive
        {Message, 1} ->
            io:format("~p receive ~p:~p~n", [self(), 1, Message]),
            NextPid ! {Message, 1},
            stop;
        {Message, Counter} ->
            io:format("~p receive ~p:~p~n", [self(), Counter, Message]),
            case IsLast of
                true ->
                    NextPid ! {Message, Counter - 1},
                    loop(NextPid, IsLast);
                false ->
                    NextPid ! {Message, Counter},
                    loop(NextPid, IsLast)
            end
    end.
