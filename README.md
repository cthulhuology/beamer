beamer - a different way of building erlang applications
---------------------------------------------------------

beamer is a module for compiling, making, and loading Erlang
modules with a rather different approach.  

Using it
--------

First step is to set your ~/.erlang file to use beamer for

	{ ok, [[Home]]} = init:get_argument(home).	
	code:add_patha(Home ++ "/.beamer").
	code:load_file(beamer).

This will add the ~/.beamer directory to your module search
path and then loads beamer.  If you want beamer to load all
of your .beam files add the line:

	beamer:load_all().

To the end.

Compiling Modules:
------------------

By default we expect the structure of the directory to be:

   ../.git
     - src/*.erl
     - README.md

If you want to compile all of the *.erl in your current work project,
(where the src directory is) you can use:

	beamer:make().

If you want to compile another project somewhere else you can say:

	beamer:make("D:/code/my_project/").

Where it is the path to where the project's "src/" directory lives.

You can also compile a specific file using:

	beamer:compile("D:/code/my_project/src/some.erl").

And you can then load a specific module using the command:

	beamer:load(some).

All of the .beam files that beamer compiles for you will be in your ~/.beamer/
directory and this works fine as long as you don't have multiple modules with
the same name.

Command Line Tools:
-------------------
j
There's also a escript and a bat file for compiling things on the command line.

	./beamer make

Will run beamer:make() and

	./beamer make d:/code/my_project

Will run beamer:make("d:/code/my_project").

You can also compile an individual file using

	./beamer compile src/some.erl





