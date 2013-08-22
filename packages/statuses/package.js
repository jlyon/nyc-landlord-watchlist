Package.describe({
  summary: "A pattern to display application status to the user"
});

Package.on_use(function (api, where) {
  api.use(['minimongo', 'bootstrap', 'handlebars', 'mongo-livedata', 'templating'], 'client');
  api.add_files(['statuses.js', 'statuses_list.html', 'statuses_list.js'], 'client');
});

Package.on_test(function(api) {
  api.use('statuses', 'client');
  api.use(['tinytest', 'test-helpers'], 'client');

  api.add_files('statuses_tests.js', 'client');
});
