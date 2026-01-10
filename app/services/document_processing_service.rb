class DocumentProcessingService
  CHUNK_SIZE = 500
  CHUNK_OVERLAP = 50

  def initialize(document)
    @document = document
    @embedding_service = EmbeddingService.new
  end

  def process
    text = extract_text
    @document.update!(content: text)

    chunks = split_into_chunks(text)
    create_chunks_with_embeddings(chunks)
  end

  private

  def extract_text
    return @document.content if @document.content.present?

    if @document.file.attached?
      case @document.file.content_type
      when 'application/pdf'
        extract_from_pdf
      when 'text/plain'
        extract_from_text
      else
        raise "Unsupported file type: #{@document.file.content_type}"
      end
    else
      ''
    end
  end

  def extract_from_pdf
    require 'pdf-reader'

    @document.file.open do |file|
      reader = PDF::Reader.new(file.path)
      reader.pages.map(&:text).join("\n\n")
    end
  end

  def extract_from_text
    @document.file.download
  end

  def split_into_chunks(text)
    return [] if text.blank?

    words = text.split(/\s+/)
    chunks = []
    position = 0

    while position < words.length
      chunk_words = words[position, CHUNK_SIZE]
      chunk_text = chunk_words.join(' ')

      chunks << {
        content: chunk_text,
        position: chunks.length
      }

      position += (CHUNK_SIZE - CHUNK_OVERLAP)
    end

    chunks
  end

  def create_chunks_with_embeddings(chunks)
    chunks.each do |chunk_data|
      embedding = @embedding_service.generate(chunk_data[:content])

      @document.chunks.create!(
        content: chunk_data[:content],
        position: chunk_data[:position],
        embedding: embedding
      )
    end
  end
end
