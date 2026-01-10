class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :destroy]

  def index
    @conversations = current_user.conversations.recent.limit(20)
  end

  def show
    @messages = @conversation.chat_messages.chronological
    @new_message = ChatMessage.new
  end

  def create
    @conversation = current_user.conversations.create!(
      title: params[:title] || "New Conversation",
      language: params[:language] || 'en'
    )

    respond_to do |format|
      format.html { redirect_to @conversation }
      format.turbo_stream
    end
  end

  def destroy
    @conversation.destroy

    respond_to do |format|
      format.html { redirect_to conversations_path, notice: 'Conversation deleted.' }
      format.turbo_stream
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end
