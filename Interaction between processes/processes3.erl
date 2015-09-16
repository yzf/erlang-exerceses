-module(processes3).
-export([start/3, center_loop/3, other_loop/0]).

start(N, M, Message) ->
    OtherPids = lists:map(
                    fun(_X) ->
                        spawn(?MODULE, other_loop, [])
                    end,
                    lists:seq(1, N)),
    spawn(?MODULE, center_loop, [OtherPids, M, Message]),
    ok.

center_loop(OtherPids, 0, _Message) ->
    lists:foreach(
        fun(Pid) ->
            Pid ! stop
        end,
        OtherPids),
    stop;
center_loop(OtherPids, M, Message) ->
    lists:foreach(
        fun(Pid) ->
            Pid ! {self(), Message},
            io:format("Center send to ~p: ~p~n", [Pid, Message]),
            receive
                {Pid, Message} ->
                    io:format("Center receive from ~p: ~p~n", [Pid, Message])
            end
        end,
        OtherPids),
    center_loop(OtherPids, M - 1, Message).

other_loop() ->
    receive
        {Pid, Message} ->
            io:format("~p receive from center: ~p~n", [self(), Message]),
            Pid ! {self(), Message},
            io:format("~p send to center: ~p~n", [self(), Message]),
            other_loop();
        stop ->
            stop
    end.
