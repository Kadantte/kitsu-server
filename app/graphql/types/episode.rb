# frozen_string_literal: true

class Types::Episode < Types::BaseObject
  implements Types::Interface::Unit
  implements Types::Interface::WithTimestamps

  description 'An Episode of a Media'

  key fields: %w[id]

  def self.resolve_reference(reference, _context)
    Loaders::UnscopedRecordLoader.for(::Episode).load(reference[:id])
  end

  field :length, Integer,
    null: true,
    description: 'The length of the episode in seconds'

  field :released_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When this episode aired',
    method: :airdate

  field :anime, Types::Anime,
    null: false,
    description: 'The anime this episode is in'
end
