class Chunk < ApplicationRecord
  belongs_to :document

  has_neighbors :embedding

  validates :content, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(position: :asc) }

  def self.search_similar(query_embedding, limit: 5)
    nearest_neighbors(:embedding, query_embedding, distance: "cosine").limit(limit)
  end
end
