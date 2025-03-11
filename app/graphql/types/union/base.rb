# frozen_string_literal: true

class Types::Union::Base < GraphQL::Schema::Union
  include ApolloFederation::Union

  def self.default_graphql_name
    "#{super}Union"
  end
end
