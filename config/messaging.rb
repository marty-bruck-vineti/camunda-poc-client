#
# Add your destination definitions here
# can also be used to configure filters, and processor groups
#
ActiveMessaging::Gateway.define do |s|
  #s.destination :orders, '/queue/Orders'
  #s.filter :some_filter, :only=>:orders
  #s.processor_group :group1, :order_processor
  
  s.destination :order_service_poc, '/queue/OrderServicePoc'
  s.destination :workflow_poc, '/queue/WorkflowPoc'

end