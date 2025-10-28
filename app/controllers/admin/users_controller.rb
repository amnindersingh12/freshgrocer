# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:update]

    def index
      @users = User.order(created_at: :desc).page(params[:page]).per(20)
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'User role updated successfully.'
      else
        redirect_to admin_users_path, alert: 'Failed to update user role.'
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:role)
    end
  end
end
