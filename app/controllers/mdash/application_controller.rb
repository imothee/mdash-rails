module Mdash
  class ApplicationController < ActionController::Base
    before_action :authenticate_token!

    private

    def authenticate_token!
      unless Mdash.config.secret.present?
        return render json: { error: "Mdash secret is not set" }, status: 500
      end

      unless Mdash.config.secret.length > 10
        return render json: { error: "Mdash secret is too short" }, status: 500
      end

      unless request.headers["X-Mdash-Token"] == Mdash.config.secret
        return render json: { error: "Unauthorized" }, status: 401
      end
    end
  end
end
