module Api
  module V1
    class ProfilesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_api_user

      def show
        render json: serialize_user(@current_api_user)
      end

      def update
        if @current_api_user.update(user_params)
          render json: serialize_user(@current_api_user)
        else
          render json: { errors: @current_api_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def serialize_user(user)
        {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          bio: user.respond_to?(:bio) ? (user.bio || '') : '',
          commissions_enabled: user.respond_to?(:commissions_enabled) ? (user.commissions_enabled.nil? ? true : user.commissions_enabled) : true,
          avatar_url: user.avatar.attached? ? rails_blob_url(user.avatar, only_path: false) : nil
        }
      end

      def user_params
        params.require(:user).permit(:name, :bio, :commissions_enabled, :avatar)
      end
    end
  end
end