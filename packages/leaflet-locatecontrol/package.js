Package.describe({
  summary: "A smart package that integrates with the L.geosearch plugin for Leaflet."
});

Package.on_use(function (api) {
  api.add_files('leaflet-locatecontrol/src/L.Control.Locate.js', 'client');
  api.add_files('leaflet-locatecontrol/src/L.Control.Locate.css', 'client');
});
