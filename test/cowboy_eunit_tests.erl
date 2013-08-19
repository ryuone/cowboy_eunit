%% Copyright
-module(cowboy_eunit_tests).
-author("ryuone").

-include_lib("eunit/include/eunit.hrl").

setup() ->
    io:format(user, "setup~n", []),
    application:start(crypto),
    application:start(ranch),
    application:start(cowboy),
    application:start(cowboy_eunit),
    ok.
cleanup(_) ->
    io:format(user, "cleanup~n", []),
    application:stop(cowboy_eunit),
    application:stop(cowboy),
    application:stop(ranch),
    application:stop(crypto),
    ok.
ascii_subtest() ->
    RequestHeaders = [{<<"connection">>, <<"keep-alive">>}],
    {ok, Client1} = cowboy_client:init([]),
    {ok, Client2} = cowboy_client:request(<<"GET">>, <<"http://127.0.0.1:8080/?echo=test">>, RequestHeaders, Client1),
    {ok, Result, _Client3} = parse_response(Client2),

    Status = proplists:get_value(status, Result),
    Headers = proplists:get_value(headers, Result),
    ContentLength = proplists:get_value(<<"content-length">>, Headers),
    Body = proplists:get_value(body, Result),
%%     ?debugVal(Result),
    [
        ?assertMatch(<<"4">>, ContentLength),
        ?assertMatch(<<"test">>, Body),
        ?assertMatch(200, Status)
    ].
utf8_subtest() ->
    RequestHeaders = [{<<"connection">>, <<"keep-alive">>}],
    {ok, Client1} = cowboy_client:init([]),
    {ok, Client2} = cowboy_client:request(<<"GET">>, <<"http://127.0.0.1:8080/?echo=あいうえお">>, RequestHeaders, Client1),
    {ok, Result, _Client3} = parse_response(Client2),

    Status = proplists:get_value(status, Result),
    Headers = proplists:get_value(headers, Result),
    ContentLength = proplists:get_value(<<"content-length">>, Headers),
    Body = proplists:get_value(body, Result),
%%     ?debugVal(Body),
    [
        ?assertMatch(<<"15">>, ContentLength),
        ?assertMatch(<<"あいうえお">>, Body),
        ?assertMatch(200, Status)
    ].

main_test_() ->
%%     io:format(user, "main_test_~n", []),
    {
        setup,
        fun setup/0,
        fun cleanup/1,
        {inparallel, [fun ascii_subtest/0, fun utf8_subtest/0]}
    }.

parse_response(Client) ->
    {ok, Code, _Msg, Client2} = cowboy_client:stream_status(Client),
    {ok, Headers, Client3} = cowboy_client:stream_headers(Client2),
    {ok, Body, Client4} = cowboy_client:stream_body(Client3),
    {ok, [{status, Code}, {headers, Headers}, {body, Body}], Client4}.
