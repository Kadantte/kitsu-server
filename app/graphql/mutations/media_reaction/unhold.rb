# frozen_string_literal: true

class Mutations::MediaReaction::Unhold < Mutations::Base
  include FancyMutation

  directive Directive::SitePermission, required: 'community_mod'

  description 'Mark a held reaction as fine, unholding it.'

  input do
    argument :media_reaction_id, ID, required: true
  end
  result Types::Post
  errors Types::Errors::NotAuthorized,
    Types::Errors::NotAuthenticated,
    Types::Errors::NotFound

  def ready?(media_reaction_id:)
    authenticate!
    @reaction = MediaReaction.find_by(id: media_reaction_id)
    return errors << Types::Errors::NotFound.build if @reaction.nil?
    authorize!(@reaction, :unhold?)
    true
  end

  def resolve(**)
    @reaction.update!(hidden_at: nil)
    @reaction
  end
end
