const gulp = require("gulp");
const elm  = require("gulp-elm");
const sass = require("gulp-sass");
const del  = require("del");

const clean_dirs = [
  "docs/",
  "elm-stuff/",
];

const sass_dirs = [
  "src/sass/**/*.sass",
  "node_modules/bulma/bulma.sass"
];

const css_dirs = [
  "node_modules/@creativebulma/bulma-tooltip/dist/bulma-tooltip.css",
  "node_modules/@creativebulma/bulma-collapsible/dist/css/bulma-collapsible.min.css"
];

const js_dirs = [
  "node_modules/@creativebulma/bulma-collapsible/dist/js/bulma-collapsible.min.js"
];

gulp.task("clean", () => {
  return del(clean_dirs);
});

gulp.task("html", () => {
  return gulp.src("src/html/**")
    .pipe(gulp.dest("docs/"));
});

gulp.task("elm", () => {
  return gulp.src("src/elm/Main.elm")
    .pipe(elm({ optimize: true }))
    .pipe(gulp.dest("docs/js/"));
});

gulp.task("js", () => {
  return gulp.src(js_dirs)
    .pipe(gulp.dest("docs/js/"));
});

gulp.task("sass", () => {
  return gulp.src(sass_dirs)
    .pipe(sass())
    .pipe(gulp.dest("docs/css/"));
});

gulp.task("css", () => {
  return gulp.src(css_dirs)
    .pipe(gulp.dest("docs/css/"));
});

gulp.task("default",
  gulp.series(
    "clean",
    gulp.parallel(
      "html",
      "elm",
      "sass",
      "css",
      "js",
    )
  )
);
