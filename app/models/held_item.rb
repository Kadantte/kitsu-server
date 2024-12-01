# frozen_string_literal: true

class HeldItem < ApplicationRecord
  def readonly?
    true
  end
end
