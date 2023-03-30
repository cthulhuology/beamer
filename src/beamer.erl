%% beamer - doing bad things with beam files
%%
%% MIT No Attribution  
%% Copyright 2023 David J Goehrig <dave@dloh.org>
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy 
%% of this software and associated documentation files (the "Software"), to 
%% deal in the Software without restriction, including without limitation the 
%% rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
%% sell copies of the Software, and to permit persons to whom the Software is 
%% furnished to do so.  
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
%% IN THE SOFTWARE.


-module(beamer).
-author({ "David J Goehrig", "dave@dloh.org"}).
-copyright(<<"© 2023 David J. Goehrig"/utf8>>).
-export([ load_all/0, load/1, compile/1, make/0, make/1 ]).

green(Term) ->
	io:format([ 16#1b | "[;32m"]),
	io:format("~p", [ Term ]),
	io:format([ 16#1b | "[;39m" ]).

red(Term) ->
	io:format([ 16#1b | "[;31m"]),
	io:format("~p", [ Term ]),
	io:format([ 16#1b | "[;39m" ]).

compile(Filename) ->
	{ ok, Path } = init:get_argument(home),
	case compile:file(Filename, [ report,debug_info,{outdir, Path ++ "/.beamer"} ]) of
		{ ok, Module } ->
			io:format("Compiled module ~p ", [ Module ]),
			green("ok"),
			io:format("~n");
		{ ok, Module, Warnings} ->
			io:format("~p~n", [ Warnings ]),
			io:format("Compiled module ~p ", [ Module ]),
			green("ok"),
			io:format("~n");
		{ error, Errors, Warnings } ->
			io:format("~p~n", [ Warnings ]),
			red(Errors),
			io:format("~n")
	end.

load_all() ->
	{ ok, Path } = init:get_argument(home),
	{ ok, Files } = file:list_dir(Path ++ "/.beamer"),
	code:add_patha(Path ++ "/.beamer"),
	Modules = [ list_to_atom(lists:nth(1,string:tokens(F,"."))) || F <- Files, lists:suffix(".beam",F)],	
	[ code:purge(M) || M <- Modules, M =/= beamer ],
	[ code:load_file(M) || M <- Modules, M =/= beamer ].

load(Module) ->
	{ ok, Path } = init:get_argument(home),
        code:purge(Module),
	case code:load_abs( Path ++ "/.beamer/" ++ atom_to_list(Module) ++ ".beam") of
		{ error, Error } ->
			red(Error),
			io:format("~n");
		{ module, Module } ->
			green(Module),
			io:format("~n")
	end.
	
make(Path) ->
	{ ok, Files } = file:list_dir(Path ++ "/src/"),
	[ beamer:compile(Path ++ "/src/" ++ F) || F <- Files, lists:suffix(".erl",F) ].

make() ->
	{ ok, Files } = file:list_dir("src/"),
	[ beamer:compile("src/" ++ F) || F <- Files, lists:suffix(".erl",F) ].

