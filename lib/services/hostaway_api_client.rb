module Services
  class HostawayApiClient
    API_URL = 'https://api.hostaway.com/v1'
    CREDENTIALS = Rails.application.credentials.hostaway_api

    attr_reader :params, :token_type, :access_token

    def initialize(params = '')
      @params = params
    end

    def fetch_reservations
      authenticate
      response = HTTParty.get(
        "#{API_URL}/reservations?#{params}",
        headers: {
          'Cache-control' => 'no-cache',
          'Authorization' => "#{token_type} #{access_token}"
        }
      )
      response
    end

    private

    def authenticate
      body = "grant_type=client_credentials&client_id=#{CREDENTIALS.client_id}&client_secret=#{CREDENTIALS.client_secret}&scope=general"
      response = HTTParty.post(
        "#{API_URL}/accessTokens",
        body: body,
        headers: {
          'Cache-control' => 'no-cache',
          'Content-type' => 'application/x-www-form-urlencoded'
        }
      )
      @token_type = response['token_type']
      @access_token = response['access_token']
    end
  end
end
