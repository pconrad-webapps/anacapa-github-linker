module Api
  module V1
    class Users < Grape::API
      resources :users do
        desc 'List Users'#, resource: Api::Resources::V1::User
        # paginate
        get do
          present User.all, with: Api::V1::Entities::User
        end
      end
    end
  end
end
