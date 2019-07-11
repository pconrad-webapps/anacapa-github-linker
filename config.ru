# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rack::Cascade.new [Rails.application, Api::V1::Root]

