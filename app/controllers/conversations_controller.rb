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
      title: params[:title] || I18n.t('chat.new_conversation_title', default: 'New Conversation'),
      language: params[:language] || I18n.locale.to_s
    )

    redirect_to @conversation, status: :see_other
  end

  def destroy
    @conversation.destroy
    redirect_to conversations_path,
                status: :see_other,
                notice: t('flash.conversation_deleted')
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end
