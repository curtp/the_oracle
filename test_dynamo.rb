require 'dynamoid'
Dynamoid.configure do |config|
  config.namespace = "dynamoid_development"
  config.endpoint = "http://dynamodb-local:8000"
end

class User
  include Dynamoid::Document
  field name
end

Dynamoid.config.logger.level = :debug
