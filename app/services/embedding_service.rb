class EmbeddingService
  MODEL = 'text-embedding-3-small'

  def initialize
    @client = OpenAI::Client.new
  end

  def generate(text)
    response = @client.embeddings(
      parameters: {
        model: MODEL,
        input: text.to_s.strip
      }
    )

    response.dig('data', 0, 'embedding')
  rescue StandardError => e
    Rails.logger.error "Embedding generation failed: #{e.message}"
    raise e
  end

  def generate_batch(texts)
    texts.map { |text| generate(text) }
  end
end
