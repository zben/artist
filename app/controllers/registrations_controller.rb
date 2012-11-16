# encoding: UTF-8

# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    if !['boston2012', nil].include?(params[:user][:invitation_code]) && params["user"]["_type"] == "IndUser"
      flash[:error] = "Artist registration currently is by invitation only. If you don't have a valid invitation code, please email us to be invited."
      if params[:is_homepage]
        redirect_to :back
      else
        @user = User.new
        render :new
      end
    else
      user = User.where(:email=>params[:user][:email]).first
      if user!=nil && user.invitation_sent_at!=nil && user.invitation_accepted_at.nil?
        redirect_to accept_user_invitation_path+"?invitation_token=#{user.invitation_token}"
      else
        params[:user][:_type]
        I18n.locale = cookies[:locale] = params[:user][:_type] == "IndUser" ? :en : :ch
        super
      end
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
