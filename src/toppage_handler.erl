%% Copyright
-module(toppage_handler).
-author("ryuone").

%% API
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {Method, Req2} = cowboy_req:method(Req),
    {Echo, Req3} = cowboy_req:qs_val(<<"echo">>, Req2),
    {ok, Req4} = echo(Method, Echo, Req3),
    {ok, Req4, State}.

echo(<<"GET">>, undefined, Req) ->
    cowboy_req:reply(400, [], <<"Missing echo parameter.">>, Req);
echo(<<"GET">>, Echo, Req) ->
    cowboy_req:reply(200,
        [{<<"content-encoding">>, <<"utf-8">>}], Echo, Req);
echo(_, _, Req) ->
    %% Method not allowed.
    cowboy_req:reply(405, Req).

terminate(_Reason, _Req, _State) ->
    ok.
