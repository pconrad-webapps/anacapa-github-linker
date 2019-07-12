module Api
  module V1
    class Users < Base
      resources :users do
        desc 'List Users', resource: Api::Resources::V1::User
        paginate
        get do
          present User.all
        end
      end
    end
  end
end
