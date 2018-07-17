require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'googleauth'
require 'google/apis/calendar_v3'

module Boundaries
  module Infra
    class Authorization
      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
      CLIENT_SECRETS_PATH = 'secrets/client_secrets_creditas.json'.freeze
      CREDENTIALS_PATH = 'secrets/token.yaml'.freeze
      SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

      def credentials
        client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
        authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
        user_id = 'default'
        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
          url = authorizer.get_authorization_url(base_url: OOB_URI)
          puts 'Open the following URL in the browser and enter the ' \
            "resulting code after authorization:\n" + url
          code = gets
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
          )
        end
        credentials
      end

    end
  end
end
