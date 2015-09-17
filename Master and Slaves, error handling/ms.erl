-module(ms).
-export([start/1, to_slave/2]).
-export([start_slaves/1, master_loop/1, slave_loop/1, get_slave/2,
         restart_slave/2]).

start(NumSlave) ->
    register(master, spawn(?MODULE, start_slaves, [NumSlave])).

to_slave(Message, N) ->
    master ! {Message, N}.

start_slaves(NumSlave) ->
    process_flag(trap_exit, true),
    % [{N, Pid}, ...]
    Slaves = lists:map(fun(N) ->
                               {N, spawn_link(?MODULE, slave_loop, [N])}
                       end,
                       lists:seq(1, NumSlave)),
    master_loop(Slaves).

master_loop(Slaves) ->
    receive
        {Message, N} ->
            get_slave(Slaves, N) ! Message,
            master_loop(Slaves);
        {'EXIT', _FromPid, {die, N}} ->
            NewSlaves = restart_slave(Slaves, N),
            io:format("master restarting dead slave~p~n", [N]),
            master_loop(NewSlaves)
    end.

slave_loop(N) ->
    receive
        die ->
            exit({die, N});
        Msg ->
            io:format("Slave ~p got message ~p~n", [N, Msg]),
            slave_loop(N)
    end.

get_slave(Slaves, N) ->
    erlang:element(2, lists:keyfind(N, 1, Slaves)).

restart_slave(Slaves, N) ->
    Pid = spawn_link(?MODULE, slave_loop, [N]),
    lists:keyreplace(N, 1, Slaves, {N, Pid}).
