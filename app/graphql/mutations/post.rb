# frozen_string_literal: true

class Mutations::Post < Mutations::Namespace
  field :lock,
    mutation: Mutations::Post::Lock,
    description: 'Lock a Post.'

  field :unlock,
    mutation: Mutations::Post::Unlock,
    description: 'Unlock a Post.'

  field :create,
    mutation: Mutations::Post::Create,
    description: 'Create a Post.'

  field :delete,
    mutation: Mutations::Post::Delete,
    description: 'Delete a Post.'

  field :unhold,
    mutation: Mutations::Post::Unhold,
    description: 'Mark a held Post as fine, unholding it.'
end
