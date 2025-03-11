# frozen_string_literal: true

class Types::BaseArgument < GraphQL::Schema::Argument
  include ApolloFederation::Argument
end
