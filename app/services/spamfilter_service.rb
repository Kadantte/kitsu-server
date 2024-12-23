# frozen_string_literal: true

class SpamfilterService
  Result = Struct.new(:label, :confidence) do
    def spam?
      label == 'Spam'
    end

    def ham?
      label == 'Ham'
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

  ENDPOINT_NAME = ENV.fetch('SPAMFILTER_ENDPOINT', nil)
  CLIENT = Aws::SageMakerRuntime::Client.new(
    region: ENV.fetch('SPAMFILTER_REGION', nil),
    access_key_id: ENV.fetch('SPAMFILTER_ACCESS_KEY_ID', nil),
    secret_access_key: ENV.fetch('SPAMFILTER_SECRET_ACCESS_KEY', nil)
  )

  def self.call(account_age_hours:, content:)
    response = CLIENT.invoke_endpoint(
      endpoint_name: ENDPOINT_NAME,
      content_type: 'text/csv',
      body: CSV.generate_line(account_age_hours, content)
    )

    label, confidence = CSV.parse_line(response.body.string)
    Result.new(label, confidence.to_f)
  end
end
