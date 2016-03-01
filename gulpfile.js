var SprocketsChain = require("sprockets-chain");
var runSequence=require("run-sequence");
var concat = require('gulp-concat');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var tap = require("gulp-tap");
var path = require('path');
var sass = require('gulp-sass');
var flatten = require('gulp-flatten');
var mkdirp = require('mkdirp');

var targetDir = "web";
mkdirp(targetDir);

var sc = new SprocketsChain();
sc.appendPath("web-src")
sc.appendPath("web-src/javascripts")
sc.appendPath("web-src/stylesheets")
sc.appendPath("/usr/local/lib/ruby/gems/2.2.0/gems/dashing-1.3.4/stylesheets")
sc.appendExtensions( [ ".scss", ".css" ]);

var gulp = require('gulp');

gulp.task('scripts', function() {
    var chain = sc.depChain("javascripts/application.coffee")
      .filter(function(f) {
        var ext = path.extname(f);
        return ext === ".js" || ext === ".coffee";
      })
    return gulp.src(chain)
    .pipe(tap(function(file, t) {
      if (path.extname(file.path) === ".coffee") {
        return t.through(coffee);
      }
    })).on('error', gutil.log)
    .pipe(concat("application.js"))
    .pipe(gulp.dest(targetDir+"/javascripts"));
});

gulp.task("sass", function() {
  var chain = sc.depChain("stylesheets/application.scss")
    .filter(function(f) {
      var ext = path.extname(f);
      return ext === ".css" || ext === ".scss";
    })
  return gulp.src(chain)
  .pipe(tap(function(file, t) {
    if (path.extname(file.path) === ".scss") {
      return t.through(sass);
    }
  })).on('error', sass.logError)
  .pipe(concat("application.css"))
  .pipe(gulp.dest(targetDir+"/stylesheets"));
});

gulp.task("views", function() {
  return gulp.src("web-src/widgets/**/*.html")
  .pipe(flatten())
  .pipe(gulp.dest(targetDir+"/views/"));
});

gulp.task("fonts", function() {
  return gulp.src("web-src/fonts/*")
  .pipe(gulp.dest(targetDir+"/fonts"));
});

gulp.task('default', function() {
  runSequence( ['scripts', 'sass', 'views', 'fonts']);
})
