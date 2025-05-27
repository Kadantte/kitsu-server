# frozen_string_literal: true

class Types::Producer < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A company involved in the creation or localization of media'

  key fields: %w[id]

  def self.resolve_reference(reference, _context)
    Loaders::UnscopedRecordLoader.for(::Producer).load(reference[:id])
  end

  # Identifiers
  field :id, ID, null: false

  field :name, String,
    null: false,
    description: 'The name of this production company'
end
