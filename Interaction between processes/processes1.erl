-module(processes1).
-export([start/2, receive_loop/0, send_loop/3]).

start(N, Message) ->
    Pid1 = spawn_link(?MODULE, receive_loop, []),
    spawn_link(?MODULE, send_loop, [Pid1, N, Message]),
    ok.

receive_loop() ->
    receive
        {Pid, {message, Message}} ->
            io:format("receive_loop got: ~p~n", [Message]),
            Pid ! {message, Message},
            io:format("receive_loop send: ~p~n", [Message]),
            receive_loop();
        {_Pid, exit} ->
            stop
    end.

send_loop(Pid, 0, _) ->
    Pid ! {self(), exit},
    stop;
send_loop(Pid, N, Message) ->
    Pid ! {self(), {message, Message}},
    io:format("send_loop send: ~p~n", [Message]),
    receive
        {message, Message2} ->
            io:format("send_loop got: ~p~n", [Message2]),
            send_loop(Pid, N - 1, Message)
    end.
