require "test_helper"

class ChunkTest < ActiveSupport::TestCase
  setup do
    @alice = User.create!(email: "alice-#{SecureRandom.hex(4)}@example.com", password: "password123")
    @bob   = User.create!(email: "bob-#{SecureRandom.hex(4)}@example.com",   password: "password123")

    @alice_doc = Document.create!(user: @alice, title: "Alice doc", content: "alice content", status: "completed")
    @bob_doc   = Document.create!(user: @bob,   title: "Bob doc",   content: "bob content",   status: "completed")

    @alice_chunk = @alice_doc.chunks.create!(content: "alice secret tax info", position: 0).tap do |c|
      c.update!(embedding: [1.0, 0.0, 0.0])
    end
    @bob_chunk = @bob_doc.chunks.create!(content: "bob secret tax info", position: 0).tap do |c|
      c.update!(embedding: [1.0, 0.0, 0.0])
    end
  end

  test "search_similar only returns chunks from the requesting user's documents" do
    results = Chunk.search_similar([1.0, 0.0, 0.0], user: @alice, limit: 10)

    assert_includes results, @alice_chunk
    refute_includes results, @bob_chunk, "Bob's chunks must never appear in Alice's retrieval results"
  end

  test "search_similar returns empty array when user has no chunks" do
    isolated = User.create!(email: "iso-#{SecureRandom.hex(4)}@example.com", password: "password123")
    results = Chunk.search_similar([1.0, 0.0, 0.0], user: isolated, limit: 10)

    assert_empty results
  end

  test "search_similar fallback path is also user-scoped" do
    # Force the rescue branch by passing an embedding that triggers a failure
    # in cosine_similarity (nil triggers the StandardError path indirectly via map).
    # Easier: stub cosine_similarity to raise.
    Chunk.singleton_class.send(:alias_method, :__orig_cs, :cosine_similarity)
    Chunk.define_singleton_method(:cosine_similarity) { |_a, _b| raise "boom" }

    results = Chunk.search_similar([1.0, 0.0, 0.0], user: @alice, limit: 10).to_a

    assert_includes results, @alice_chunk
    refute_includes results, @bob_chunk
  ensure
    Chunk.singleton_class.send(:alias_method, :cosine_similarity, :__orig_cs)
  end
end
