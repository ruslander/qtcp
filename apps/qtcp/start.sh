clear
rebar clean compile
erl -pa ebin -eval "application:start(qtcp)"