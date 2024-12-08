# frozen_string_literal: true

class SpamfilterService
  class NyckelError < StandardError; end
  class NotAuthorizedError < NyckelError; end
  Result = Struct.new(:labelName, :confidence) do
    def spam?
      labelName == 'Spam'
    end

    def ham?
      labelName == 'Ham'
    end

    def spamminess
      if spam?
        confidence
      else
        # Ham has a hamminess score (inverse of spamminess)
        1.0 - confidence
      end
    end
  end

  NYCKEL_URL = 'https://www.nyckel.com'
  NYCKEL_FUNCTION = ENV.fetch('NYCKEL_FUNCTION', nil)

  def self.call(account_age_hours:, content:)
    Retriable.retriable(
      on_retry: -> { refresh_token! },
      on: [NotAuthorizedError]
    ) do
      response = HTTP.auth("Bearer #{access_token}").post(
        "#{NYCKEL_URL}/v1/functions/#{NYCKEL_FUNCTION}/invoke",
        json: { data: { account_age_hours:, content: } }
      )
      body = JSON.parse(response.body.to_s)

      raise NotAuthorizedError if response.code == 401
      raise NyckelError, body.message if response.code != 200

      Result.new(body['labelName'], body['confidence'])
    end
  end

  def self.access_token
    refresh_token! if @access_token.nil? || @access_token.expired?

    @access_token.token
  end

  def self.refresh_token!
    @access_token = oauth2.get_token
  end

  def self.oauth2
    OAuth2::Client.new(
      ENV.fetch('NYCKEL_CLIENT_ID', nil),
      ENV.fetch('NYCKEL_CLIENT_SECRET', nil),
      site: NYCKEL_URL,
      token_url: '/connect/token'
    ).client_credentials
  end
end
