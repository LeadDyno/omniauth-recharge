require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Recharge < OmniAuth::Strategies::OAuth2

      option :provider_ignores_state, true

      option :client_options, {
          :site          => 'https://admin.rechargeapps.com',
          :authorize_url => '/oauth/authorize',
          :token_url     => '/oauth/token'
      }

      uid{ raw_info['store']['store_id'] }

      info do
        {
            :email => raw_info['store']['email'],
        }
      end

      extra do
        {
            'raw_info' => raw_info['store']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://api.rechargeapps.com/').parsed
      end

      # recharge doesnt like it when the query params are also passed because it breaks redirect url matching
      def callback_url
        full_host + script_name + callback_path
      end

    end
  end
end
