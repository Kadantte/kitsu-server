# frozen_string_literal: true

module Types::Interface::Holdable
  include Types::Interface::Base

  description 'User-generated content which can be held for moderation'

  field :held_reason, Types::Enum::HeldReason,
    null: true,
    description: 'The reason this content was held for moderation'
end
