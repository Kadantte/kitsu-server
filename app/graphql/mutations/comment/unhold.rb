# frozen_string_literal: true

class Mutations::Comment::Unhold < Mutations::Base
  include FancyMutation

  directive Directives::SitePermission, required: 'community_mod'

  description 'Mark a held Comment as fine, unholding it.'

  input do
    argument :comment_id, ID, required: true
  end
  result Types::Comment
  errors Types::Errors::NotAuthorized,
    Types::Errors::NotAuthenticated,
    Types::Errors::NotFound

  def ready?(comment_id:)
    authenticate!
    @comment = Comment.find_by(id: comment_id)
    return errors << Types::Errors::NotFound.build if @comment.nil?
    authorize!(@comment, :unhold?)
    true
  end

  def resolve(**)
    @comment.update!(held_reason: nil)
    @comment
  end
end
