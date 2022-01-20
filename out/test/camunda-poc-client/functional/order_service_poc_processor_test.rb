require File.dirname(__FILE__) + '/../test_helper'
require 'activemessaging/test_helper'
require File.dirname(__FILE__) + '/../../app/processors/application_processor'

class OrderServicePocProcessorTest < Minitest::Test
  include ActiveMessaging::TestHelper
  
  def setup
    load File.dirname(__FILE__) + "/../../app/processors/order_service_poc_processor.rb"
    @processor = OrderServicePocProcessor.new
  end
  
  def teardown
    @processor = nil
  end  

  def test_order_service_poc_processor
    @processor.on_message('Your test message here!')
  end
end