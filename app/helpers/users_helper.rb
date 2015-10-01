module UsersHelper
  def conversation_receiver conversation
    conversation.sender == current_user ? conversation.receiver : conversation.sender
  end
end
