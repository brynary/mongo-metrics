require "mongo_metrics"
Fixture::Application.config.middleware.use MongoMetrics
