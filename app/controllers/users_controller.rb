class UsersController < ApplicationController
  before_action :load_user, only: %i[archive unarchive]

  # http://localhost:3000/users?keyword=archive / keyword=unarchive
  def index
    check = params[:keyword] == "archive" ? true : false
    user = params[:keyword].present? ? User.where(archive: check) : User.all
    render jsonapi: user
  end

  # http://localhost:3000/users/:id/archive
  def archive
    if @user.update_attribute :archive, true
      UserMailer.inform_email(@user,current_user).deliver
      render json: { success: true, message: 'User Archived Successfully'}, status: :ok
    else
      render json: { success: false, message: 'Errors', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # http://localhost:3000/users/:id/unarchive
  def unarchive
    if @user.update_attribute :archive, false
      UserMailer.inform_email(@user,current_user).deliver
      render json: { success: true, message: 'User Unarchived Successfully'}, status: :ok
    else
      render json: { success: false, message: 'Errors', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def load_user
    return render json: { success: false, message: 'Errors', errors: ["You can't archive or unarchive yourself."] }, status: :unprocessable_entity if current_user.id == params[:id].to_i
    @user = User.find_by(id: params[:id])
  end
end
