module Api
  module V1
    class Root < Grape::API
      version 'v1', using: :header, vendor: 'anacapa'
      format :json
      prefix :api

      mount Api::V1::Users
    end
  end
end
