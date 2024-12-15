SELECT 'Post' AS type, id, created_at FROM posts
WHERE posts.held_reason IS NOT NULL
  AND posts.deleted_at IS NULL

UNION ALL

SELECT 'Comment' AS type, id, created_at FROM comments
WHERE comments.held_reason IS NOT NULL
  AND comments.deleted_at IS NULL

UNION ALL

SELECT 'MediaReaction' AS type, id, created_at FROM media_reactions
WHERE media_reactions.held_reason IS NOT NULL
  AND media_reactions.deleted_at IS NULL
