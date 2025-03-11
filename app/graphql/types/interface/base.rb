# frozen_string_literal: true

module Types::Interface::Base
  extend ActiveSupport::Concern
  include GraphQL::Schema::Interface
  include HasImageField
  include ApolloFederation::Interface

  field_class Types::BaseField
end
