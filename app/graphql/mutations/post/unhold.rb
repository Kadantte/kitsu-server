# frozen_string_literal: true

class Mutations::Post::Unhold < Mutations::Base
  include FancyMutation

  directive Directive::SitePermission, required: 'community_mod'

  description 'Mark a held Post as fine, unholding it.'

  input do
    argument :id, ID, required: true
  end
  result Types::Post
  errors Types::Errors::NotAuthorized,
    Types::Errors::NotAuthenticated,
    Types::Errors::NotFound

  def ready?(id:)
    authenticate!
    @post = Post.find_by(id:)
    return errors << Types::Errors::NotFound.build if @post.nil?
    authorize!(@post, :unhold?)
    true
  end

  def resolve(**)
    @post.update!(hidden_at: nil)
    @post
  end
end
