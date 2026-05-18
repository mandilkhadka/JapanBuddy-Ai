require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "conv-#{SecureRandom.hex(4)}@example.com", password: "password123")
    sign_in @user
  end

  test "POST create succeeds via plain HTML and redirects to the new conversation (regression: previously crashed on turbo_stream.redirect_to)" do
    assert_difference -> { @user.conversations.count }, +1 do
      post "/conversations"
    end
    convo = @user.conversations.order(:created_at).last
    assert_redirected_to "/en/conversations/#{convo.id}"
    assert_equal 303, response.status
  end

  test "POST create also succeeds via Turbo Stream accept header" do
    assert_difference -> { @user.conversations.count }, +1 do
      post "/conversations", headers: { "Accept" => "text/vnd.turbo-stream.html, text/html" }
    end
    # 303 lets Turbo follow the redirect on POST without re-POSTing
    assert_includes [302, 303], response.status
  end

  test "DELETE destroy removes the conversation and flashes the localized notice" do
    convo = @user.conversations.create!(title: "to delete", language: "en")

    assert_difference -> { @user.conversations.count }, -1 do
      delete "/conversations/#{convo.id}"
    end
    assert_redirected_to "/en/conversations"
    assert_equal I18n.t("flash.conversation_deleted"), flash[:notice]
  end

  test "user cannot see another user's conversation on GET show" do
    other = User.create!(email: "other-#{SecureRandom.hex(4)}@example.com", password: "password123")
    foreign = other.conversations.create!(title: "secret", language: "en")

    get "/conversations/#{foreign.id}"
    assert_response :not_found
  end
end
