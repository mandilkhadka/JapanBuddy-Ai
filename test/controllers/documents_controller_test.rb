require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "doc-ctrl-#{SecureRandom.hex(4)}@example.com", password: "password123")
    sign_in @user

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

  test "create enqueues processing job for content-only uploads (regression: previously only fired when a file was attached)" do
    assert_enqueued_with(job: ProcessDocumentJob) do
      post documents_path, params: {
        document: { title: "Tax Notes", content: "Tax filing deadline is mid-March each year in Japan." }
      }
    end

    assert_redirected_to documents_path
    assert_equal I18n.t("flash.document_uploaded"), flash[:notice]
  end

  test "create does not enqueue processing when both file and content are blank" do
    assert_no_enqueued_jobs(only: ProcessDocumentJob) do
      post documents_path, params: { document: { title: "Empty Doc" } }
    end
  end
end
