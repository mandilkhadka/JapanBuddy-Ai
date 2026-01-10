class ChatMessagesController < ApplicationController
  before_action :set_conversation

  def create
    @user_message = params[:content]

    respond_to do |format|
      format.turbo_stream do
        @user_chat_message = @conversation.add_message(role: 'user', content: @user_message)

        ai_service = AiAnswerService.new(@conversation)
        @ai_response = ai_service.answer(@user_message)
        @ai_chat_message = @conversation.chat_messages.where(role: 'assistant').last
      end
      format.html { redirect_to @conversation }
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end
end
