class FacebookController < ApplicationController
  def client  
    OAuth2::Client.new(FACEBOOK_API_KEY, FACEBOOK_API_SECRET, :site => 'https://graph.facebook.com')  
  end
  
  def auth
    redirect_to client.web_server.authorize_url(  
      :redirect_uri => redirect_uri,   
      :scope => 'email,offline_access'  
    )  
  end
    
  #facebook's OAuth callback
  def callback 
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
    fb_user = JSON.parse(access_token.get('/me'))  
    @user = User.find_by_facebook_id(fb_user["id"]) || User.find_by_email(fb_user["email"]) || User.new
    @user.update_attributes({
      :facebook_id => fb_user["id"],
      :first_name => fb_user["first_name"],
      :last_name => fb_user["last_name"],
      :gender => fb_user["gender"],
      :email => fb_user["email"],
      :timezone => fb_user["timezone"],
      :locale => fb_user["locale"],
      :facebook_url => fb_user["link"],
      :facebook_access_token => access_token.token
    }) unless @user.updated_at < 2.days.ago
    
    @user_session = UserSession.create(@user, true)
    
    flash[:success] = "Welcome, #{@user.name}"
    redirect_to :root
  end  
    
  def redirect_uri  
    uri = URI.parse(request.url)  
    uri.path = facebook_callback_path
    uri.query = nil  
    uri.to_s
  end
  

end