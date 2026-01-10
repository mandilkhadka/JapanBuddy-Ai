class AiAnswerService
  MODEL = 'gpt-4o-mini'
  MAX_CONTEXT_CHUNKS = 5

  SYSTEM_PROMPT = <<~PROMPT
    You are JapanBuddy AI, a helpful multilingual assistant for foreigners living in Japan.
    You help with questions about:
    - Immigration procedures (visa renewal, residence cards, etc.)
    - Health insurance and pension systems
    - Taxes and municipal services
    - Understanding official documents (bills, city hall notices, etc.)
    - Daily life in Japan

    When answering:
    - Be clear and concise
    - Provide step-by-step guidance when appropriate
    - Highlight important deadlines or urgent matters
    - If you reference specific documents or procedures, cite the source
    - If you're unsure about something, say so and suggest where to find accurate information

    If provided with context from documents, use that information to give accurate answers.
    Always respond in the same language the user is using.
  PROMPT

  def initialize(conversation)
    @conversation = conversation
    @client = OpenAI::Client.new
    @embedding_service = EmbeddingService.new
  end

  def answer(user_message)
    @conversation.add_message(role: 'user', content: user_message)

    context = retrieve_relevant_context(user_message)
    response = generate_response(user_message, context)

    @conversation.add_message(role: 'assistant', content: response)
    @conversation.touch

    response
  end

  def stream_answer(user_message, &block)
    @conversation.add_message(role: 'user', content: user_message)

    context = retrieve_relevant_context(user_message)
    full_response = ''

    messages = build_messages(user_message, context)

    @client.chat(
      parameters: {
        model: MODEL,
        messages: messages,
        stream: proc do |chunk, _bytesize|
          content = chunk.dig('choices', 0, 'delta', 'content')
          if content
            full_response += content
            block.call(content) if block_given?
          end
        end
      }
    )

    @conversation.add_message(role: 'assistant', content: full_response)
    @conversation.touch

    full_response
  end

  private

  def retrieve_relevant_context(query)
    return '' unless Chunk.exists?

    query_embedding = @embedding_service.generate(query)
    relevant_chunks = Chunk.search_similar(query_embedding, limit: MAX_CONTEXT_CHUNKS)

    return '' if relevant_chunks.empty?

    context_parts = relevant_chunks.map.with_index do |chunk, index|
      "[Document: #{chunk.document.title}]\n#{chunk.content}"
    end

    "Relevant context from knowledge base:\n\n#{context_parts.join("\n\n---\n\n")}"
  end

  def build_messages(user_message, context)
    messages = [{ role: 'system', content: SYSTEM_PROMPT }]

    @conversation.chat_messages.order(:created_at).last(10).each do |msg|
      next if msg.content == user_message && msg.role == 'user'
      messages << { role: msg.role, content: msg.content }
    end

    if context.present?
      messages << { role: 'user', content: "#{context}\n\nUser question: #{user_message}" }
    else
      messages << { role: 'user', content: user_message }
    end

    messages
  end

  def generate_response(user_message, context)
    messages = build_messages(user_message, context)

    response = @client.chat(
      parameters: {
        model: MODEL,
        messages: messages,
        temperature: 0.7,
        max_tokens: 1000
      }
    )

    response.dig('choices', 0, 'message', 'content') || 'I apologize, but I was unable to generate a response. Please try again.'
  end
end
