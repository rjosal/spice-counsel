require 'client/ls_search_client'
require 'client/api_client'

class HomeController < ApplicationController
  layout 'spice'

  before_filter :login_required, :get_current_user, :update_session_expiration, :except => [:login, :logout]

  SEARCH_CLIENT = LsSearchClient.new

  def index
  end

  def search
    Rails.logger.info 'SEARCHING'
#TODO add a tag filter here no matter what so that only relevant spicy restaurants get shown
    res = SEARCH_CLIENT.search(params[:query], params[:place])
    render :partial => 'search_results', :locals => {:results => res}
  end





  # check credentials and log in
  def login
    @title = 'Login'
    if request.post?
      @user = User.authenticate( params[:user][:email], params[:user][:password] )
      if !@user.nil?
        session[:user_id] = @user.id
        flash[:message] = "Successfully logged in as #{@user.name}"
        @user.update_attribute(:last_login, Time.now.utc)
        update_session_expiration
        redirect_back :controller => 'home'
      else
        flash[:warning] = "Login failed. Please check the email and password."
      end
    end
  end
  
  # logout; destroy cookies
  def logout
    session[:user_id] = nil
    flash[:message] = "Successfully logged out."
    redirect_to :controller => 'home', :action => 'login'
  end

  private

  # base authentication filter for all gui functionality
  def login_required
    return true if session[:user_id] && (session[:expiration] && (session[:expiration] - Time.now).to_i > 0)
    if session[:expiration]
      flash[:warning] = 'Your session has expired. Please log in again.'
      session[:expiration] = nil
    else
      flash[:message] = 'You need to login to access that page.'
    end
    redirect_away :controller => 'home', :action => 'login'
  end
  
  def update_session_expiration
    session[:expiration] = 3.hours.from_now
  end

  # if there's no session, but a persistent login,
  # reassign the user to the session
  # this maintains persistent logins across cookie expiration
  def get_current_user
    if !session[:user_id].nil?
      @user = User.find_by_id( session[:user_id] )
    end
  end
  
  #saves users location before redirecting
  def redirect_away(*params)
    session[:original_uri] = request.request_uri
    redirect_to(*params)
  end

  #return to original url, or default
  def redirect_back(*params)
    uri = session[:original_uri]
    session[:original_uri] = nil
    if uri
      redirect_to uri
    else
      redirect_to(*params)
    end
  end
end
