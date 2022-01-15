class WorkflowPocProcessor < ApplicationProcessor
  subscribes_to :workflow_poc

  def on_message(message)
    logger.debug "WorkflowPocProcessor received: " + message

    my_message = Message.create!(body: message, received_date: DateTime.now)

  end
end