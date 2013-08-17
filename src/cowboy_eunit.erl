%% Copyright
-module(cowboy_eunit).
-author("ryuone").

%% API
-export([start/0]).

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(cowboy_eunit).
