Package.describe({
  summary: "Simple wrapper adds jquery UI carousel"
});

Package.on_use(function (api, where) {
  api.add_files([
    'dist/css/jquery.rs.carousel.css',
    'vendor/jquery.ui.widget.js', 
    'vendor/jquery.event.drag.js', 
    'dist/js/jquery.rs.carousel.js',
    'dist/js/jquery.rs.carousel-touch.js'
  ], 'client');
});
