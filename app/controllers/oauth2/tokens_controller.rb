class Oauth2::TokensController < ApplicationController
  before_filter :authenticate_user!

  def create
    @refresh_token = oauth2_current_refresh_token || RefreshToken.to_adapter.create!(:client_id => oauth2_current_client.id, :user_id => current_user.id)
    @access_token = AccessToken.to_adapter.create!(:refresh_token => @refresh_token, :client_id => oauth2_current_client.id, :user_id => current_user.id)
    render :json => @access_token.token_response
  end
  private
  def oauth2_current_client
   env['oauth2.client'] 
  end
  def oauth2_current_refresh_token
    env['oauth2.refresh_token']
  end
end
