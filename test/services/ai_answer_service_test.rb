require "test_helper"

class AiAnswerServiceTest < ActiveSupport::TestCase
  setup do
    @alice = User.create!(email: "ai-alice-#{SecureRandom.hex(4)}@example.com", password: "password123")
    @bob   = User.create!(email: "ai-bob-#{SecureRandom.hex(4)}@example.com",   password: "password123")

    @alice_doc = Document.create!(user: @alice, title: "Alice tax memo", content: "x", status: "completed")
    @bob_doc   = Document.create!(user: @bob,   title: "Bob secrets",    content: "x", status: "completed")

    @alice_chunk = @alice_doc.chunks.create!(content: "Alice owns this. Tax filing deadline is March 15.", position: 0).tap do |c|
      c.update!(embedding: [1.0, 0.0, 0.0])
    end
    @bob_chunk = @bob_doc.chunks.create!(content: "Bob's confidential pension info.", position: 0).tap do |c|
      c.update!(embedding: [1.0, 0.0, 0.0])
    end

    @convo = @alice.conversations.create!(title: "tax", language: "en")

    EmbeddingService.class_eval do
      alias_method :__orig_generate, :generate
      define_method(:generate) { |_| [1.0, 0.0, 0.0] }
    end

    @captured_messages = []
    OpenAI::Client.class_eval do
      alias_method :__orig_chat, :chat if method_defined?(:chat)
    end
    captured = @captured_messages
    OpenAI::Client.define_method(:chat) do |parameters:|
      captured << parameters[:messages]
      { "choices" => [{ "message" => { "content" => "stubbed reply" } }] }
    end
  end

  teardown do
    EmbeddingService.class_eval do
      alias_method :generate, :__orig_generate
      remove_method :__orig_generate
    end
    OpenAI::Client.class_eval do
      remove_method :chat
      alias_method :chat, :__orig_chat if method_defined?(:__orig_chat)
      remove_method :__orig_chat if method_defined?(:__orig_chat)
    end
  end

  test "answer persists user + assistant messages and returns the reply" do
    svc = AiAnswerService.new(@convo)
    reply = svc.answer("When is tax filing due?")

    assert_equal "stubbed reply", reply
    assert_equal 2, @convo.chat_messages.count
    roles = @convo.chat_messages.order(:created_at).pluck(:role)
    assert_equal %w[user assistant], roles
  end

  test "answer injects context only from the conversation owner's chunks (no cross-user leakage)" do
    AiAnswerService.new(@convo).answer("tax filing deadline?")

    payload = @captured_messages.last.map { |m| m[:content] }.join("\n")
    assert_match "Alice owns this", payload
    refute_match "Bob's confidential", payload, "Bob's chunks must never leak into Alice's prompt"
  end

  test "answer falls back gracefully when the user has zero chunks" do
    isolated = User.create!(email: "iso-#{SecureRandom.hex(4)}@example.com", password: "password123")
    convo = isolated.conversations.create!(title: "x", language: "en")

    reply = AiAnswerService.new(convo).answer("anything?")
    assert_equal "stubbed reply", reply
    # No context block prepended — only the system + bare user question
    payload = @captured_messages.last.map { |m| m[:content] }.join("\n")
    refute_match "Relevant context from knowledge base", payload
  end
end
