# frozen_string_literal: true

class Types::Quote < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A quote from a media'

  key fields: %w[id]

  def self.resolve_reference(reference, _context)
    Loaders::UnscopedRecordLoader.for(::Quote).load(reference[:id])
  end

  # Identifiers
  field :id, ID, null: false

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media this quote is excerpted from'

  field :lines, Types::QuoteLine.connection_type,
    null: false,
    description: 'The lines of the quote'

  def lines
    Loaders::AssociationLoader.for(Quote, :lines, policy: :quote_line).scope(object).then(&:to_a)
  end
end
