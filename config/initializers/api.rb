# frozen_string_literal: true

# Allow API requests to be authenticated via the rails session cookie
Grape::Middleware::Auth::Strategies.add(:cookie, Api::Auth::Cookie)

Rails.application.config.to_prepare do
  AfJsonApi.setup do |config|
    #
    # Set the API base URL. This will be used when generating links to API resources.
    #
    # TODO: REPLACE THIS WITH SOMETHING THAT DETERMINES CURRENT URL
    # config.base_url = -> { AfRuntime::Core::RemoteServices.instance.uri_for('tportal').merge('/api') }

    #
    # Namespaces to search for API resource classes. This allows the API to automatically
    # look up resources by class name.
    # For example, when looking up a resource class for
    #   `Property`
    # it would search for
    #   `Api::Resources::V1::Property`
    #
    config.resource_namespaces = [
      'Api::Resources::V1'
    ]

    config.root_endpoint = Api::V1::Root
    config.documentation_title = 'Project Anacapa'
  end
end
