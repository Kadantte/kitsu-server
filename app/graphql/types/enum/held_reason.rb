# frozen_string_literal: true

class Types::Enum::HeldReason < Types::Enum::Base
  description 'The reason a record is held for manual moderator approval.'

  value 'SPAMFILTER', 'Caught by a spam filter.', value: 'spamfilter'
  value 'WORDFILTER', 'Caught by a word filter.', value: 'wordfilter'
end
