# Kettle

Kettle is an extension for the code editor Brackets that adds automatic compilation of CoffeeScript files upon saving.
It is a fork of another [auto-compiler](https://github.com/jdiehl/brackets-less-autocompile/). It also supports
`coffeescriptimproved` mode defined in the [giovannicalo's](https://github.com/giovannicalo) CoffeeScript
[extension](https://github.com/giovannicalo/brackets-coffeescript).


### Installation

Kettle is installed from the Brackets Extension Manager. Please restart Brackets after installing the extension.


### Compile Options

Kettle compile options can be set in the first line of the edited file:
For example:

    # out: ../dist/app.js, sourceMap: true

The following compile options are available:

* out: redirect the js output to a different file. Default: your-coffeescript-filename.js
* sourceMap: generate a source map. Default: false
* sourceMapFilename: source map filename. Default: your-coffeescript-filename.js.map
* sourceMapURL: source map url (Optional)
* sourceMapRoot: source map root (Optional)

### TODO

* Add project-wide compilation options
* Add compression compilation options
* Hiding .js files after compilation
* Hiding sourcemap files after compilation

### FAQ

How can I redirect the output to a separate file?

> Add the following line to the head of your coffeescript file:
>
>     # out: new-file.js

How can I supress the compilation of a single coffeescript file

> Set out to null
>
>     # out: none
>       -or-
>     # out: false
### Acknowledgements

Thanks to [Jonathan Diehl](https://github.com/jdhiel) for his work on the less auto-compiler.

### License
The MIT License (MIT)

Copyright (c) 2015 Nelson Kamga

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
