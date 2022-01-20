class OrderServicePocProcessor < ApplicationProcessor
  require 'net/http'

  subscribes_to :order_service_poc

  ##
  # Response message has the format:
  #     String processInstanceId;
  #     String activeTaskId;
  #     Map<String, Object> variables;
  #
  def on_message(message)

    logger.debug "OrderServicePocProcessor received: " + message
    # wait 5 seconds, then return the order_location
    json = JSON.parse(message)
    response_queue = json['response_listener_queue']
    response = {processInstanceId:json['process_instance_id'],
                activeTaskId: json['activity_id'],
                completionEventName: json['completion_signal_name'],
                variables: {
                  order_location: 'Armenia'
                }}
    client = Stomp::Client.new()
    sleep(3)
    client.publish("/queue/#{response_queue}", response.to_json)
    client.close
  end
end