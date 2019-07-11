module Api
  module V1
    module Entities
      class User < Grape::Entity
        expose :name
        expose :admin do |user, _options|
          user.has_role? :admin
        end
        expose :instructor do |user, _options|
          user.has_role? :instructor
        end
      end
    end
  end
end