# encoding: UTF-8

# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    user = User.where(:email=>params[:user][:email]).first
    if user!=nil && user.invitation_sent_at!=nil && user.invitation_accepted_at.nil?
      redirect_to accept_user_invitation_path+"?invitation_token=#{user.invitation_token}"
    else
      super
    end
  end

  def update
    super
  end

  def after_inactive_sign_up_path_for(resource)
    flash[:notice]= "Please check for an email from us"
    new_user_session_path
  end
end
