module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500

      protected

      def return500
        render status: :internal_server_error, json: { errors: [I18n.t('server_error')] }
      end
    end
  end
end
