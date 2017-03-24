Package.describe({
  summary: "JavaScript minifier",
  // Be sure to skip 2.0.0, as the beta versions are already used.
  version: "1.2.19-rc.1"
});

Npm.depends({
  "uglify-js": "2.7.5"
});

Npm.strip({
  "uglify-js": ["test/"]
});

Package.onUse(function (api) {
  api.export(['UglifyJSMinify', 'UglifyJS']);
  api.addFiles(['minifier.js'], 'server');
});

Package.onTest(function (api) {
  api.use('minifier-js', 'server');
  api.use('tinytest');

  api.addFiles([
    'beautify-tests.js',
  ], 'server');
});
