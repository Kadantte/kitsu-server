# frozen_string_literal: true

class Connections::HoldableConnection < GraphQL::Pagination::ActiveRecordRelationConnection
  def initialize
    super(HeldItem.order(created_at: :desc))
  end

  def limited_nodes
    held_items = super
    loaded_items = held_items.group_by(&:type).to_h do |key, items|
      [key, key.constantize.find(items.map(&:id)).index_by(&:id)]
    end
    held_items.map do |item|
      loaded_items.dig(item.type, item.id)
    end
  end
end
