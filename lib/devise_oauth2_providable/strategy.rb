require 'devise/strategies/base'

module Devise
  module Strategies
    class Oauth2Providable < Authenticatable
      def valid?
        @req = Rack::OAuth2::Server::Resource::Bearer::Request.new(env)
        @req.oauth2?
      end
      def authenticate!
        @req.setup!
        token = AccessToken.find_by_token(@req.access_token)
        token = (token and not token.expired?) ? token : nil
        env['oauth2.client'] = token ? token.client : nil
        resource = token ? token.user : nil
        if validate(resource)
          success! resource
        elsif !halted?
          fail(:invalid_token)
        end
      end
    end
  end
end

Warden::Strategies.add(:oauth2_providable, Devise::Strategies::Oauth2Providable)
