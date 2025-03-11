# frozen_string_literal: true

class Types::Enum::Base < GraphQL::Schema::Enum
  include ApolloFederation::Enum

  enum_value_class Types::Enum::BaseValue

  def self.default_graphql_name
    "#{super}Enum"
  end
end
