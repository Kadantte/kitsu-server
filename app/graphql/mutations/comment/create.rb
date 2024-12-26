# frozen_string_literal: true

class Mutations::Comment::Create < Mutations::Base
  include FancyMutation

  description 'Create a Comment'

  input do
    argument :content, String, required: true,
      description: 'The (markdown-formatted) content of the comment'
    argument :post_id, ID, required: true,
      description: 'The ID of the post to comment on'
    argument :parent_id, ID, required: false,
      description: 'The ID of the parent comment when replying'
    argument :embed_url, String, required: false,
      description: 'The URL to embed in the comment'
  end
  result Types::Comment
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotFound,
    Types::Errors::NotAuthorized,
    Types::Errors::Validation

  def ready?(post_id:, content:, parent_id: nil)
    authenticate!
    @post = Post.find_by(id: post_id)
    @parent = Comment.find_by(id: parent_id) if parent_id
    return errors << Types::Errors::NotFound.build if @post.nil?
    return errors << Types::Errors::NotFound.build if parent_id && @parent.nil?
    @comment = Comment.new(post: @post, content:, user: current_user, parent: @parent)
    authorize!(@comment, :create?)
    true
  end

  def resolve(**)
    @comment.tap(&:save!)
  end
end
