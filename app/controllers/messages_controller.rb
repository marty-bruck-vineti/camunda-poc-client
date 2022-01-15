class MessagesController < ApplicationController
  def index
    @messages = Message.take(100)
  end

  def clear
    Message.delete_all
    redirect_to messages_path
  end
end
