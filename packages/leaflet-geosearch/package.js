Package.describe({
  summary: "A smart package that integrates with the L.geosearch plugin for Leaflet."
});

Package.on_use(function (api) {
  api.add_files('L.GeoSearch/src/js/leaflet.control.geosearch.js', 'client');
  api.add_files('L.GeoSearch/src/js/leaflet.geosearch.provider.google.js', 'client');
  api.add_files('L.GeoSearch/src/css/leaflet-control-geosearch.css', 'client');
});
