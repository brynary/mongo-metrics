Mongo Metrics
=============

Rack middleware to record web requests to MongoDB
-------------------------------------------------

* Homepage: [http://github.com/brynary/mongo-metrics](http://github.com/brynary/mongo-metrics)

Install
-------

1. Add mongo-metrics to your Gemfile:

        gem "mongo-metrics"

2. In config/initializers/mongo_metrics.rb, add:

        YourApp::Application.config.middleware.use MongoMetrics

Authors
-------

- Maintained by [Bryan Helmkamp](mailto:bryan@brynary.com)

Development
-----------

For development, you'll need Bundler...

License
-------

See MIT-LICENSE.txt in this directory.
