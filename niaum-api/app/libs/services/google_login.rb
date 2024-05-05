module Services
  class GoogleLogin
    def initialize(access_token:, scope:, token_type:)
      @access_token = access_token
      @scope = scope
      @token_type = token_type
    end

    def user
      # call google api to get user info

      endpoint = URI.parse("https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{@access_token}")

      http = Net::HTTP.new(endpoint.host, endpoint.port)

      http.use_ssl = true

      request = Net::HTTP::Get.new(endpoint.request_uri)

      response = http.request(request)

      if response.code == '200'
        JSON.parse(response.body)
      else
        raise Api::Exceptions::Base, status: 422, messages: [
          'Something went wrong while trying to login with Google',
          response.body
        ]
      end
    end
  end
end
