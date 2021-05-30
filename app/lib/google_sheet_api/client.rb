# cf. https://developers.google.com/sheets/api/quickstart/ruby
# rubocop:disable Rails/Output
module GoogleSheetApi
  class Client
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    APPLICATION_NAME = '幻水総選挙2021'.freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

    def initialize(credentials_path: nil, token_path: nil)
      @credentials_path = credentials_path || Rails.root.join('google_api_credentials.json')
      @token_path       = token_path || Rails.root.join('google_api_token.yml')
    end

    def create
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize

      service
    end

    def authorize
      client_id   = Google::Auth::ClientId.from_file @credentials_path
      token_store = Google::Auth::Stores::FileTokenStore.new file: @token_path
      authorizer  = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
      user_id     = 'default'
      credentials = authorizer.get_credentials user_id

      if credentials.nil?
        url = authorizer.get_authorization_url base_url: OOB_URI

        puts "Open the following URL in the browser and enter the " \
                "resulting code after authorization:\n" + url

        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id,
          code: code,
          base_url: OOB_URI
        )
      end

      credentials
    end
  end
end
# rubocop:enable Rails/Output
