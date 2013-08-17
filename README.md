# rebar

    $ git clone git://github.com/basho/rebar.git
    $ cd rebar
    $ make

    $ ./rebar -h
    $ ./rebar -c
    $ ./rebar list-template         # Get template list

    $ ./rebar create-app appid=cowboy_eunit
    $ ./rebar compile


    $ erl
    1> erlang:system_info(version).
    "5.10.1"
    2> erlang:system_info(otp_release).
    "R16B"

    $ ./rebar -vvv compile
    $ ./rebar list-deps             # Error
    $ ./rebar get-deps
