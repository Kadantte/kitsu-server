# frozen_string_literal: true

RSpec.describe Mutations::Comment::Create do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let(:post) { create(:post) }

  query = <<~GRAPHQL
    mutation commentCreateMutation($input: CommentCreateInput!) {
      comment {
        create(input: $input) {
          errors {
            ...on Error {
              __typename
            }
          }
          result {
            parent { id }
            post { id }
            id
            content
          }
        }
      }
    }
  GRAPHQL

  context 'with a valid top-level comment' do
    it 'creates the comment' do
      response = execute_query(query, input: {
        content: 'Hello, world!',
        postId: post.id
      })
      expect(response.dig('data', 'comment', 'create', 'result')).to match(
        a_hash_including(
          'id' => an_instance_of(String),
          'post' => { 'id' => post.id.to_s },
          'content' => 'Hello, world!'
        )
      )
    end
  end

  context 'with a valid reply' do
    let(:parent) { create(:comment, post:) }

    it 'creates the comment' do
      response = execute_query(query, input: {
        content: 'Hello, world!',
        postId: post.id,
        parentId: parent.id
      })
      expect(response.dig('data', 'comment', 'create', 'result')).to match(
        a_hash_including(
          'id' => an_instance_of(String),
          'post' => { 'id' => post.id.to_s },
          'content' => 'Hello, world!',
          'parent' => { 'id' => parent.id.to_s }
        )
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, input: {
        content: 'Hello, world!',
        postId: post.id
      })
      expect(response.dig('data', 'comment', 'create', 'errors')).to include(
        a_hash_including('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
