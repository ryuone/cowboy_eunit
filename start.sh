#!/bin/sh
erl -pa ebin deps/*/ebin -s cowboy_eunit \
	-eval "io:format(\"Point your browser at http://localhost:8080/?echo=test~n\")."
