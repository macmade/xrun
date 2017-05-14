Xrun
====

[![Build Status](https://img.shields.io/travis/macmade/xrun.svg?branch=master&style=flat)](https://travis-ci.org/macmade/xrun)
[![Coverage Status](https://img.shields.io/coveralls/macmade/xrun.svg?branch=master&style=flat)](https://coveralls.io/r/macmade/xrun?branch=master)
[![Issues](http://img.shields.io/github/issues/macmade/xrun.svg?style=flat)](https://github.com/macmade/xrun/issues)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg?style=flat)
![License](https://img.shields.io/badge/license-mit-brightgreen.svg?style=flat)
[![Contact](https://img.shields.io/badge/contact-@macmade-blue.svg?style=flat)](https://twitter.com/macmade)  
[![Donate-Patreon](https://img.shields.io/badge/donate-patreon-yellow.svg?style=flat)](https://patreon.com/macmade)
[![Donate-Gratipay](https://img.shields.io/badge/donate-gratipay-yellow.svg?style=flat)](https://www.gratipay.com/macmade)
[![Donate-Paypal](https://img.shields.io/badge/donate-paypal-yellow.svg?style=flat)](https://paypal.me/xslabs)

About
-----

...

Installation
------------

...

Exampes
-------

...

Usage
-----

    Usage: xrun [-h] [-v] [actions...] [-project <projectname>] [-schemes <schemename>...]
    
    Available actions:
        
        --build     Build Xcode scheme(s), invoking `xcodebuild`.
                    This requires the `-schemes` argument.
        
        --analyze   Analyze Xcode scheme(s), invoking `xcodebuild`.
                    This requires the `-schemes` argument.
                    Note that unlike `xcodebuild`, an analysis failure will
                    result in a non-zero exit status.
        
        --test      Test Xcode scheme(s), invoking `xcodebuild`.
                    This requires the `-schemes` argument.
        
        --clean     Clean Xcode scheme(s), invoking `xcodebuild`.
                    This requires the `-schemes` argument.
        
        --setup     Performs initial setip and install additional dependancies.
                    You would typically execute this in the `install:` hook.
        
        --coverage  Uploads code coverage data, if available, to coveralls.io.
                    You would typically execute this in the `after_success:`
                    hook.
    
    Options:
        
       -h           Shows the command usage.
       -v           Shows the Xrun version number.
       -project     Specifies the Xcode project.
                    If none, defaults to the first available Xcode project file.
       -schemes     Schemes to build.
                    You can pass multiple schemes, separated by a space.

Example Travis configuration
----------------------------

...

License
-------

Xrun is released under the terms of the MIT license.

Repository Infos
----------------

    Owner:			Jean-David Gadina - XS-Labs
    Web:			www.xs-labs.com
    Blog:			www.noxeos.com
    Twitter:		@macmade
    GitHub:			github.com/macmade
    LinkedIn:		ch.linkedin.com/in/macmade/
    StackOverflow:	stackoverflow.com/users/182676/macmade
