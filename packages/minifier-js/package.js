Package.describe({
  summary: "JavaScript minifier",
  version: "1.9.9"
});

Package.onUse(function (api) {
  api.use('babel-compiler');
  api.export(['meteorBabelMinify']);
  api.addFiles(['minifier.js'], 'server');
});

Package.onTest(function (api) {
  // TODO: Make tests for the package
});
