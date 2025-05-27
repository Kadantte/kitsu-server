# frozen_string_literal: true

class Types::Chapter < Types::BaseObject
  implements Types::Interface::Unit
  implements Types::Interface::WithTimestamps

  description 'A single chapter of a manga'

  key fields: %w[id]

  def self.resolve_reference(reference, _context)
    Loaders::UnscopedRecordLoader.for(::Chapter).load(reference[:id])
  end

  field :released_at, GraphQL::Types::ISO8601Date,
    method: :published,
    null: true,
    description: 'When this chapter was released'

  field :volume, Types::Volume,
    null: true,
    description: 'The volume this chapter is in.'

  field :manga, Types::Manga,
    null: false,
    description: 'The manga this chapter is in.'

  field :length, Int,
    null: true,
    description: 'Number of pages in chapter.'
end
