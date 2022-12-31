class ApplicationController < ActionController::Base
    private
    # Handling authentication
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user
    
    def logged_in?
        current_user
    end
    helper_method :logged_in?
    
    def check_login
        redirect_to login_path, alert: "You need to log in to view this page." if current_user.nil?
    end

    rescue_from CanCan::AccessDenied do |exception|
        flash[:error] = "Sorry, you don't have access to this page"
        redirect_to home_path
      end
end
