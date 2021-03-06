---
title: API
---

:insert toc

---

To use Janus in your C++ application add the `janus.cpp` and `janus.h` files to your source folder and include the header file:

::: c++

    #include "janus.h"

The header exports a `janus::ArgParser` class which provides the public interface to the library.

Janus is written in portable C++ 11.



## Basic Usage

Initialize an argument parser, optionally specifying the application's help text and version:

::: c++

    ArgParser(string helptext = "", string version = "")

Supplying help text activates an automatic `--help` flag; supplying a version string activates an automatic `--version` flag. (Automatic `-h` and `-v` shortcuts are also activated unless registered by other options.)

You can now register your application's options and commands on the parser using the registration functions described below. Once the required options and commands have been registered, call the parser's `parse()` method to process the application's command line arguments:

::: c++

    void ArgParser::parse(int argc, char **argv)

The arguments are assumed to be `argc` and `argv` as supplied to `main()`.

Parsed option values can be retrieved from the parser instance itself.



## Register Options

Janus supports long-form options, `--foo`, with single-character shortcuts, `-f`.

An option can have an unlimited number of long and short-form aliases. Aliases are specified via the `name` parameter which accepts a string of space-separated alternatives, e.g. `"foo f"`.

Option values can be separated on the command line by either a space, `--foo 123`, or an equals symbol, `--foo=123`.


||  `void ArgParser::newFlag(string name)`  ||

    Register a flag (a boolean option) with a default value of `false`. Flag options take no arguments but are either present (`true`) or absent (`false`).


||  `void ArgParser::newDouble(string name, double fallback = 0.0)`  ||

    Register a floating-point option, optionally specifying a default value.


||  `void ArgParser::newInt(string name, int fallback = 0)`  ||

    Register an integer option, optionally specifying a default value.


||  `void ArgParser::newString(string name, string fallback = "")`  ||

    Register a string option, optionally specifying a default value.



## Retrieve A Single Value

An option's value can be retrieved from the parser instance using any of its registered aliases.

Each option maintains an internal array of values — the value of the option is the final value in the array or the fallback value if the array is empty.


||  `bool ArgParser::found(string name)`  ||

    Returns true if the specified option was found while parsing.


||  `bool ArgParser::getFlag(string name)`  ||

    Returns the value of the specified boolean option.


||  `double ArgParser::getDouble(string name)`  ||

    Returns the value of the specified floating-point option.


||  `int ArgParser::getInt(string name)`  ||

    Returns the value of the specified integer option.


||  `string ArgParser::getString(string name)`  ||

    Returns the value of the specified string option.



## Retrieve Multiple Values

An option's internal array of values can be retrieved from the parser instance using any of its registered aliases.


||  `vector<double> ArgParser::getDoubleList(string name)`  ||

    Returns the specified option's list of values.


||  `vector<int> ArgParser::getIntList(string name)`  ||

    Returns the specified option's list of values.


||  `vector<string> ArgParser::getStringList(string name)`  ||

    Returns the specified option's list of values.


||  `int ArgParser::lenList(string name)`  ||

    Returns the length of the specified option's list of values.



## Retrieve Positional Arguments

Options can be preceded, followed, or interspaced with positional arguments.


||  `string ArgParser::getArg(int index)`  ||

    Returns the positional argument at the specified index.


||  `vector<string> ArgParser::getArgs()`  ||

    Returns the positional arguments as a list of strings.


||  `vector<double> ArgParser::getArgsAsDoubles()`  ||

    Attempts to parse and return the positional arguments as a list of doubles.
    Exits with an error message on failure.


||  `vector<int> ArgParser::getArgsAsInts()`  ||

    Attempts to parse and return the positional arguments as a list of
    integers. Exits with an error message on failure.


||  `bool ArgParser::hasArgs()`  ||

    Returns true if at least one positional argument has been found.


||  `int ArgParser::numArgs()`  ||

    Returns the number of positional arguments.



## Commands

Janus supports git-style command interfaces with arbitrarily-nested commands. Register a command on a parser instance using the `newCmd()` method:

::: c++

    ArgParser& ArgParser::newCmd(string name, string helptext, void (*callback)(ArgParser& parser))

This method returns a reference to a new `ArgParser` instance associated with the command. You can register the command's flags and options on this sub-parser using the standard methods listed above. (Note that you never need to call `parse()` on a command parser --- if a command is found, its arguments are parsed automatically.)

* Like options, commands can have an unlimited number of aliases specified via the `name` string.

* Commands support an automatic `--help` flag and an automatic `help <name>` command using the specified help text.

* The specified callback function will be called if the command is found. The callback should accept a reference to the command's `ArgParser` instance as its sole argument and should return `void`.

The following `ArgParser` methods are also available for processing commands manually:


||  `string ArgParser::getCmdName()`  ||

    Returns the command name, if the parser has found a command.


||  `ArgParser& ArgParser::getCmdParser()`  ||

    Returns the command's parser instance, if the parser has found a command.


||  `ArgParser& ArgParser::getParent()`  ||

    Returns a command parser's parent parser.


||  `bool ArgParser::hasCmd()`  ||

    Returns true if the parser has found a command.


||  `bool ArgParser::hasParent()`  ||

    Returns true if the parser has a parent, i.e. is not the root parser.
