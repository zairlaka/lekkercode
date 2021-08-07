class UsersController < ApplicationController
  before_action :load_user, only: %i[archive unarchive]


  def index
    check = params[:keyword] == "archive" ? true : false
    user = params[:keyword].present? ? User.where(archive: check) : User.all
    render jsonapi: user
  end

  def archive
    if @user.update_attribute :archive, true
      render json: { success: true, message: 'User Archived Successfully'}, status: :ok
    else
      render json: { success: false, message: 'Errors', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unarchive
    if @user.update_attribute :archive, false
      
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
