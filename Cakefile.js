(function() {
  var browserify, cleanup, fileset, fse, uglifyjs;

  require('shelljs/global');

  fileset = require('fileset');

  uglifyjs = require('uglify-js');

  fse = require('fs-extra');

  browserify = require('browserify');

  cleanup = function(cb) {
    console.log('Cleaning up...');
    return fileset('build/**', 'build build/node_modules build/node_modules/**', function(err, files) {
      var file, i, len;
      console.log(files);
      if (err != null) {
        console.log(err);
      }
      for (i = 0, len = files.length; i < len; i++) {
        file = files[i];
        fse.removeSync(file);
      }
      console.log('Cleaning done !');
      return cb();
    });
  };

  task('build', 'build package for Brackets', function(options) {
    return cleanup(function() {
      console.log("Building...");
      return fileset('node/*.js *.js', 'Cakefile.js modules.js', function(err, files) {
        var file, i, len, result;
        console.log(files);
        if (err != null) {
          console.log(err);
        }
        for (i = 0, len = files.length; i < len; i++) {
          file = files[i];
          result = uglifyjs.minify(file);
          fse.outputFileSync("build/" + file, result.code);
        }
        return fileset('README.md package.json', function(err, files) {
          var j, len1;
          console.log(files);
          for (j = 0, len1 = files.length; j < len1; j++) {
            file = files[j];
            fse.copySync(file, "build/" + file);
          }
          fse.removeSync("kettle.zip");
          cd('build');
          exec('zip -9r kettle.zip *');
          return console.log('Building done !');
        });
      });
    });
  });

}).call(this);
