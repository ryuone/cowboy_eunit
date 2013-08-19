all: clean compile xref eunit

get-deps:
	@./rebar get-deps

compile:
	@./rebar compile

xref:
	@./rebar xref

clean:
	@./rebar clean

eunit:
	@./rebar eunit

edoc:
	@./rebar doc
