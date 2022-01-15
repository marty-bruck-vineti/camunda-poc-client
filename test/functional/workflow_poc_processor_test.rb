require File.dirname(__FILE__) + '/../test_helper'
require 'activemessaging/test_helper'
require File.dirname(__FILE__) + '/../../app/processors/application_processor'

class WorkflowPocProcessorTest < Minitest::Test
  include ActiveMessaging::TestHelper
  
  def setup
    load File.dirname(__FILE__) + "/../../app/processors/workflow_poc_processor.rb"
    @processor = WorkflowPocProcessor.new
  end
  
  def teardown
    @processor = nil
  end  

  def test_workflow_poc_processor
    @processor.on_message('Your test message here!')
  end
end