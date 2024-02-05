module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return_internal_server_error
      rescue_from ActiveRecord::RecordNotFound, with: :return_not_found

      protected

      def return_internal_server_error
        render status: :internal_server_error, json: { errors: [I18n.t('server_error')] }
      end

      def return_not_found
        render status: :not_found, json: { errors: [I18n.t('not_found')] }
      end
    end
  end
end
