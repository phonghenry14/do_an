class ConversationsController < ApplicationController
  layout false

  def create
    if Conversation.existing_conversation(params[:sender_id], params[:receiver_id]).present?
      @conversation = Conversation.existing_conversation(params[:sender_id], params[:receiver_id]).first
    else
      @conversation = Conversation.create! conversation_params
    end

    render json: {conversation_id: @conversation.id}
  end

  def show
    @conversations = Conversation.involving(current_user).order "created_at DESC"
    @conversation = Conversation.find params[:id]
    @receiver = conversation_receiver @conversation
    @messages = @conversation.messages
    @message = Message.new
  end

  private
  def conversation_params
    params.permit :sender_id, :receiver_id
  end
end
