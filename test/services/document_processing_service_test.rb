require "test_helper"

class DocumentProcessingServiceTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "doc-svc-#{SecureRandom.hex(4)}@example.com", password: "password123")

    EmbeddingService.class_eval do
      alias_method :__orig_generate, :generate
      define_method(:generate) { |_text| [0.1, 0.2, 0.3, 0.4, 0.5] }
    end
  end

  teardown do
    EmbeddingService.class_eval do
      alias_method :generate, :__orig_generate
      remove_method :__orig_generate
    end
  end

  test "processes a content-only document into chunks with embeddings" do
    doc = Document.create!(
      user: @user,
      title: "Visa Notes",
      content: "Renew your residence card three months before expiry. Bring passport, photo, and 4000 yen.",
      status: "pending"
    )

    DocumentProcessingService.new(doc).process

    doc.reload
    assert doc.chunks.any?, "expected chunks to be created for content-only doc"
    assert doc.chunks.all? { |c| c.embedding.present? }, "every chunk should carry an embedding"
    assert_equal (0..doc.chunks.count - 1).to_a, doc.chunks.ordered.pluck(:position)
  end

  test "process_document! transitions status pending → completed and creates chunks" do
    doc = Document.create!(
      user: @user,
      title: "Health Notes",
      content: "NHI covers 70 percent of medical costs in Japan.",
      status: "pending"
    )

    doc.process_document!

    assert_equal "completed", doc.reload.status
    assert doc.chunks.any?
  end

  test "process_document! marks the document failed on error" do
    doc = Document.create!(user: @user, title: "X", content: "ok", status: "pending")

    EmbeddingService.class_eval do
      alias_method :__before_raise, :generate
      define_method(:generate) { |_| raise "embedding API down" }
    end

    assert_raises(RuntimeError) { doc.process_document! }
    assert_equal "failed", doc.reload.status
  ensure
    EmbeddingService.class_eval do
      alias_method :generate, :__before_raise
      remove_method :__before_raise
    end
  end
end
