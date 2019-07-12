#
# Base class for all API endpoints
#
module Api
  module V1
    class Base < AfJsonApi::V1::Base
      auth :cookie

      before do
        error!(‘Access Denied’, 401) unless current_user
      end
    end
  end
end
