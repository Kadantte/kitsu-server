# frozen_string_literal: true

RSpec.describe Mutations::Comment::Unhold do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  query = <<~GRAPHQL
    mutation commentUnholdMutation($input: CommentUnholdInput!) {
      comment {
        unhold(input: $input) {
          errors {
            ...on Error {
              __typename
            }
          }
          result {
            id
            content
          }
        }
      }
    }
  GRAPHQL

  context 'when you are a community_mod' do
    let(:user) { create(:user, permissions: %i[community_mod]) }

    it 'unsets the comment held_reason' do
      comment = create(:comment, held_reason: :spamfilter)
      expect {
        execute_query(query, input: {
          commentId: comment.id
        })
      }.to change { comment.reload.held_reason }.from('spamfilter').to(nil)
    end

    it 'returns the comment' do
      comment = create(:comment, held_reason: :spamfilter)
      response = execute_query(query, input: {
        commentId: comment.id
      })
      pp 'RESPONSE', response
      expect(response.dig('data', 'comment', 'unhold', 'result')).to match(
        a_hash_including(
          'id' => comment.id.to_s,
          'content' => comment.content
        )
      )
    end
  end

  context 'when not a moderator' do
    it 'does not exist' do
      response = execute_query(query, input: {
        commentId: create(:comment).id
      })
      expect(response['errors']).to include(
        a_hash_including('message' => "Field 'unhold' doesn't exist on type 'CommentMutations'")
      )
    end
  end
end
