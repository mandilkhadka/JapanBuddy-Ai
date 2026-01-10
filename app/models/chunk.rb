class Chunk < ApplicationRecord
  belongs_to :document

  validates :content, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(position: :asc) }

  # Store embedding as JSON
  def embedding=(value)
    self.embedding_json = value.to_json if value
  end

  def embedding
    return nil if embedding_json.blank?
    JSON.parse(embedding_json)
  rescue JSON::ParserError
    nil
  end

  def self.search_similar(query_embedding, limit: 5)
    # Simple cosine similarity search using Ruby
    # For production with large datasets, use pgvector
    chunks_with_scores = all.includes(:document).map do |chunk|
      next nil if chunk.embedding.blank?

      score = cosine_similarity(query_embedding, chunk.embedding)
      [chunk, score]
    end.compact

    chunks_with_scores
      .sort_by { |_, score| -score }
      .first(limit)
      .map(&:first)
  rescue StandardError => e
    Rails.logger.warn "Similarity search failed: #{e.message}"
    order(created_at: :desc).limit(limit)
  end

  private

  def self.cosine_similarity(a, b)
    return 0.0 if a.nil? || b.nil? || a.empty? || b.empty?

    dot_product = a.zip(b).map { |x, y| x * y }.sum
    magnitude_a = Math.sqrt(a.map { |x| x**2 }.sum)
    magnitude_b = Math.sqrt(b.map { |x| x**2 }.sum)

    return 0.0 if magnitude_a.zero? || magnitude_b.zero?

    dot_product / (magnitude_a * magnitude_b)
  end
end
