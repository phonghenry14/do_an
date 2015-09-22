class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find params[:conversation_id]
    @message = @conversation.messages.build message_params
    @message.user = current_user
    @message.save!
  end

  private
  def message_params
    params.require(:message).permit :content
  end
end
