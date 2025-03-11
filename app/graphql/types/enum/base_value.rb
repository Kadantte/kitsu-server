# frozen_string_literal: true

class Types::Enum::BaseValue < GraphQL::Schema::EnumValue
  include ApolloFederation::EnumValue
end
