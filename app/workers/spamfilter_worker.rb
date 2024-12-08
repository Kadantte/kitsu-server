# frozen_string_literal: true

class SpamfilterWorker
  include Sidekiq::Worker

  def self.perform_async(record, content_field:)
    super(
      record.to_global_id.to_s,
      content_field.to_s
    )
  end

  def perform(record, content_field)
    record = GlobalID::Locator.locate(record)

    spamfilter = SpamfilterService.call(
      account_age_hours: (record.created_at - record.user.created_at) / 1.hour,
      content: record.public_send(content_field)
    )

    record.update_moderation_scores(
      scores: { nyckel_spamminess: spamfilter.spamminess },
      held_reason: spamfilter.spam? ? :spamfilter : nil
    )
  end
end
