# frozen_string_literal: true

class HeldItem < ApplicationRecord
  self.inheritance_column = nil

  def readonly?
    true
  end
end
