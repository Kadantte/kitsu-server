# frozen_string_literal: true

class Types::BaseScalar < GraphQL::Schema::Scalar
  include ApolloFederation::Scalar
end
