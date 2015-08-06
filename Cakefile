# TODO: create an optimized build/ folder and then zip
require 'shelljs/global'
fileset = require 'fileset'
uglifyjs = require 'uglify-js'
fse = require 'fs-extra'
browserify = require 'browserify'
cleanup = (cb) ->
  console.log 'Cleaning up...'
  fileset 'build/**', 'build build/node_modules build/node_modules/**', (err, files) ->
    console.log files
    console.log err if err?
    for file in files
      fse.removeSync file
    console.log 'Cleaning done !'
    cb()
task 'build', 'build package for Brackets', (options) ->
  cleanup ->
    console.log "Building..."
    fileset 'node/*.js *.js', 'Cakefile.js modules.js', (err, files) ->
      console.log files
      console.log err if err?
      for file in files
        result = uglifyjs.minify file
        fse.outputFileSync "build/#{file}", result.code
      fileset 'README.md package.json', (err, files) ->
        console.log files
        for file in files
          fse.copySync file, "build/#{file}"
        fse.removeSync "kettle.zip"
        cd 'build'
        exec 'zip -9r kettle.zip *'
        console.log 'Building done !'