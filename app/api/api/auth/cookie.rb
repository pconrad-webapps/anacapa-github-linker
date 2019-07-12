# frozen_string_literal: true

module Api
  module Auth
    class Cookie
      def initialize(app)
        @app = app
      end

      def call(env)
        warden = env['warden']
        current_user = ::Authorization.current_user
        if warden && (current_user.nil? || current_user.is_a?(::Authorization::AnonymousUser))
          ::Authorization.current_user = warden.authenticate(
            :database_authenticatable,
            scope: :user,
            store: false,
            intercept_401: false,
            failure_app: nil
          )
        end

        env['af_json_api.authenticated'] = true if authenticated?

        @app.call(env)
      end

      def authenticated?
        ::Authorization.current_user && !::Authorization.current_user.is_a?(::Authorization::AnonymousUser)
      end
    end
  end
end
