# frozen_string_literal: true

class Mutations::Post::Delete < Mutations::Base
  include FancyMutation

  description 'Delete a post'

  input do
    argument :post_id, ID,
      required: true,
      description: 'The id of the post.'
  end
  result Types::Post
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotFound,
    Types::Errors::NotAuthorized

  def ready?(post_id:, **)
    authenticate!
    @post = Post.find_by(id: post_id)
    return errors << Types::Errors::NotFound.build if @post.nil?
    authorize!(@post, :destroy?)
    true
  end

  def resolve(**)
    @post.destroy!
    @post
  end
end
