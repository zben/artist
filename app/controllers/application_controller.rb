#encoding: UTF-8

class ApplicationController < ActionController::Base
    protect_from_forgery
    before_filter :set_locale

    def authenticate!
        session[:user_return_to] = request.path
        if !user_signed_in?
            flash[:notice] = t("devise.failure.unauthenticated")
            redirect_to new_user_session_path
        elsif current_user.profile.nil? && current_user.org_profile.nil?
            logger.info params[:info]
            logger.info params[:info]!='profile'
            if params[:info]!='profile' && params[:action]!='update' 
              redirect_to ind_user_new_path(current_user.id, 'profile') if current_user.is_a? IndUser
              redirect_to org_user_new_path(current_user.id, 'profile') if current_user.is_a? OrgUser
            end
        end 
    end

    def check_owner!
    end

    def after_sign_in_path_for(resource)
      cookies[:locale] = resource.is_a?(OrgUser) ? :ch : :en
      I18n.locale = cookies[:locale]
      stored_location_for(resource) || user_specific_path(resource)
    end

    def user_specific_path(resource)
      if current_user._type=="IndUser"
          if current_user.profile
            artworks_path
          else
            ind_user_new_path(current_user.id,'profile')
          end
        else
          if current_user.org_profile
            artworks_path
          else
            org_user_new_path(current_user.id,'profile')
          end
        end
    end

    def after_invite_path_for(resource)
      new_invitation_path(resource)
    end

    def set_locale
      cookies[:locale] = params[:locale] if params[:locale]
      I18n.locale = params[:locale] if params[:locale]
    end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url
    end
end
