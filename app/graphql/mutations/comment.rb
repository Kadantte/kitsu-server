# frozen_string_literal: true

class Mutations::Comment < Mutations::Namespace
  field :create,
    mutation: Mutations::Comment::Create,
    description: 'Create a Comment.'

  field :delete,
    mutation: Mutations::Comment::Delete,
    description: 'Delete a Comment.'

  field :unhold,
    mutation: Mutations::Comment::Unhold,
    description: 'Mark a held Comment as fine, unholding it.'
end
