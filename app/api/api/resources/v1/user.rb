# serializable class for our users

module Api
  module Resources
    module V1
      class User < AfJsonApi::Resource
        attribute :name
        attribute :admin do
          @object.has_role? :admin
        end
        attribute :instructor do
          @object.has_role? :instructor
        end
      end
    end
  end
end
