module Api
  module V1
    class Users < Base
      resources :users do
        desc 'List Users', resource: Api::Resources::V1::User
        params do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get do
          if params[:per_page] && params[:page]
            present User.limit(params[:per_page]).offset(params[:per_page]*(params[:page]-1)), with: Api::V1::Entities::User
          else
            present User.all, with: Api::V1::Entities::User
          end

          #present User.page(params[:page]).per(params[:per_page]), with: Api::V1::Entities::User
        end
      end
    end
  end
end
