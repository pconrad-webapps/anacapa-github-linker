module Api
  module V1
    class Users < Base
      resources :users do
        desc 'List Users', resource: Api::Resources::V1::User
        paginate
        get do
          present User.all
        end
        route_param :id do
          params do
            optional :data, type: Hash do
              #requires :type, type: String, values: ['property_budgets']
              optional :attributes, type: Hash do
                optional :instructor, type: Boolean, documentation: { desc: 'Add/Remove instructor role' }
                optional :admin, type: Boolean, documentation: { desc: 'Add/Remove Admin role' }
              end
            end
          end
          patch do
            user = User.find(params[:id])

            unless params.dig(:data, :attributes, :instructor).nil?
              if params[:data][:attributes][:instructor]
                user.add_role(:instructor)
              else
                user.remove_role(:instructor)
              end
            end
            unless params.dig(:data, :attributes, :admin).nil?
              if params[:data][:attributes][:admin]
                user.add_role(:admin)
              else
                user.remove_role(:admin)
              end
            end

            present user.reload
          end
        end
      end
    end
  end
end
