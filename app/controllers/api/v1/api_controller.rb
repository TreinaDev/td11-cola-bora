module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500

      protected

      def return500
        render status: :internal_server_error, json: { errors: ['Erro interno de servidor.'] }
      end
    end
  end
end
