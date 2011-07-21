class ApplicationController < ActionController::Base
  include Kakule
  protect_from_forgery
  helper_method :current_user_session, :current_user, :require_user, :current_itinerary, :logged_in?

  private
    def format_date(date)
        date.strftime("%A, %B %d, %Y")
    end

    def find_or_create_guest_user
      unless current_user
        user = User.create_guest
        Itinerary.create_itinerary(user)
        @current_user = user
      end
    end

    ### Methods for user sessions

    def current_itinerary
        find_or_create_guest_user
        current_user.itineraries.last 
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def logged_in?
      current_user && !current_user.is_guest?
    end

    def require_user
      unless !current_user.is_guest?
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to dashboard_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
