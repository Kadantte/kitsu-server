# frozen_string_literal: true

class Resolvers::Base < GraphQL::Schema::Resolver
  argument_class Types::BaseArgument
end
