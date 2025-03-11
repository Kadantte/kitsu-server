# frozen_string_literal: true

class Types::BaseField < GraphQL::Schema::Field
  include ApolloFederation::Field

  argument_class Types::BaseArgument
end
