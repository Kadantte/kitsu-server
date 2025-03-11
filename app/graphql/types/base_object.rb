# frozen_string_literal: true

class Types::BaseObject < GraphQL::Schema::Object
  include HasImageField
  include ApolloFederation::Object

  connection_type_class Types::BaseConnection
  field_class Types::BaseField
  underscore_reference_keys true

  private

  def current_user
    context[:user]
  end

  def current_token
    context[:token]
  end
end
