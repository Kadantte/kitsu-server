# frozen_string_literal: true

module WithModerationScores
  extend ActiveSupport::Concern

  def update_moderation_scores(scores:, **kwargs)
    # Update using update_all to do it all as a single UPDATE call
    self.class.where(id:).update_all( # rubocop:disable Rails/SkipsModelValidations
      updated_at: Time.now,
      **kwargs,
      # Update the json in SQL to avoid races
      moderation_scores: Arel::Nodes::InfixOperation.new(
        Arel.sql('||'),
        Arel::Nodes::NamedFunction.new('coalesce', [
          self.class.arel_table[:moderation_scores],
          Arel.sql("'{}'::jsonb")
        ]),
        Arel::Nodes.build_quoted(scores.to_json)
      )
    )
  end
end
