require "test_helper"

class WorkflowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get workflow_index_url
    assert_response :success
  end
end
