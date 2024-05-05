# frozen_string_literal: true

module RequestHelpers
  def devise_token_auth_headers(user, additional_headers: {})
    user_headers = user.nil? ? {} : user.create_new_auth_token

    additional_headers.merge(user_headers)
  end

  def api_token_headers(token, additional_headers: {})
    token = token.token if token.respond_to?(:token)
    token_headers = { Authorization: "Token #{token}", HTTP_USER_AGENT: 'RSpec' }

    additional_headers.merge(token_headers)
  end

  def json_response
    if response.content_type == 'application/x-msgpack; charset=utf-8'
      MessagePack.unpack(response.body, symbolize_keys: true)
    else
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  def skip_webmock
    VCR.turn_off!
    WebMock.allow_net_connect!

    yield

    VCR.turn_on!
    WebMock.disable_net_connect!
  end
end
