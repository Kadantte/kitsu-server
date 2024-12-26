# frozen_string_literal: true

RSpec.describe Mutations::Comment::Delete do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  query = <<~GRAPHQL
    mutation commentDeleteMutation($input: CommentDeleteInput!) {
      comment {
        delete(input: $input) {
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

  context 'with a valid comment that you own' do
    it 'deletes the comment' do
      comment = create(:comment, user:)
      expect {
        execute_query(query, input: {
          commentId: comment.id
        })
      }.to change(Comment, :count).by(-1)
    end

    it 'returns the deleted comment' do
      comment = create(:comment, user:)
      response = execute_query(query, input: {
        commentId: comment.id
      })
      expect(response.dig('data', 'comment', 'delete', 'result')).to match(
        a_hash_including(
          'id' => comment.id.to_s,
          'content' => comment.content
        )
      )
    end
  end

  context 'with somebody else\'s comment' do
    it 'returns a NotAuthorized error' do
      response = execute_query(query, input: {
        commentId: create(:comment).id
      })
      expect(response.dig('data', 'comment', 'delete', 'errors')).to include(
        a_hash_including('__typename' => 'NotAuthorizedError')
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, input: {
        commentId: create(:comment).id
      })
      expect(response.dig('data', 'comment', 'delete', 'errors')).to include(
        a_hash_including('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
