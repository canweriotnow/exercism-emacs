[![badge-license](https://img.shields.io/badge/license-GPL%203-brightgreen.svg)](http://www.gnu.org/licenses/gpl-3.0.txt)
![badge-version](https://img.shields.io/badge/version-0.0.1-blue.svg)
[![Build Status](https://travis-ci.org/canweriotnow/exercism-emacs.svg?branch=master)](https://travis-ci.org/canweriotnow/exercism-emacs)

#exercism.el

An Emacs package for [exercism.io](http://exercism.io).

To jump to your exercism directory in dired mode, simply type

`M-x exercism`

Currently provides two commands via the exercism binary, which sort of work some of the time:

From an exercism exercise buffer,

`M-x exercism-submit`

will submit the current exercise.

From the context of your exercism directory tree,

`M-x exercism-fetch` should fetch any new exercises if they are available.

New:

`M-x exercism-tracks` will display all language tracks (active and inactive) in a temp buffer

## Installation

Put `exercism.el` in one of your personal module autoload directories.

I'm not pushing to [MELPA](http://melpa.milkbox.net) until this is stable.

## TODO

exercism.el currently executes the exercism shell commands, just to get an initial package together so my lazy ass doesn't have to leave emacs to submit/fetch exercism exercises

The long-range goal is to port most if not all of the [Exercism CLI](https://github.com/exercism/cli) to elisp.

Once that's done, hooking into unit testing for some of the exercism language tracks would be nice.

## Contributing

YES, PLEASE. This is my first attempt at an emacs package, so any pull requests, suggestions, issues, etc. would be greatly appreciated.


## License

Copyright (C) 2015  Jason Lewis

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
