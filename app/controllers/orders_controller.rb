class OrdersController < ApplicationController
  LOCATIONS = %w[US Europe]
  ORDER_TASK_NAME = 'Create Order'
  ORDER_SUBMIT_TASK_NAME = 'Submit Order'
  BASE_URL = 'http://localhost:8080/api/v1/'
  PROCESS_INSTANCE_PATH = 'processinstance/'

  before_action :check_for_cancel, only: [:create, :update]

  def check_for_cancel
    redirect_to root_path if params[:commit].eql?('Cancel')
  end

  def new
    @order = Order.new
    @process_instance_id = params[:process_instance_id]
    @task_id = params[:task_id]
    @locations = LOCATIONS
    url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{@process_instance_id}/steps"
    @steps = JSON.parse(RestClient.get(url))

  end

  ##
  # retrieve and validate the patient demographics. If ok, mark this task as complete
  def create
    @order = Order.new(params[:order].as_json)
    @process_instance_id = params[:process][:process_instance_id]
    @task_id = params[:process][:task_id]
    url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{@process_instance_id}/steps"
    @steps = JSON.parse(RestClient.get(url))

    if @order.valid?
      url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{params[:process][:process_instance_id]}/completeTask/#{params[:process][:task_id]}"
      begin
        response = RestClient.patch(url, params[:order].to_json, :content_type => 'application/json')

        if response.instance_values['code'].between?(200, 207)
          redirect_to root_url, notice: "#{format('Successfully completed ', ORDER_TASK_NAME)} step."
        else
          @error = 'Unable to create'
          render new_order_path
        end
      rescue StandardError => e
        @error = "Unable to create new process instance:  #{e.message}"
      end
    else
      render new_order_path
    end
  end
  ##
  # retrieve and display order information. If user confirms, update
  def edit
    @error = params[:error]
    @process_instance_id = params[:id]
    @task_id = params[:task_id]

    # get the process instance variables to populate the current order
    url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{@process_instance_id}/variables"
    response = RestClient.get(url)
    @variables = JSON.parse(response.body)
    @order = Order.new()
    @order.order_date = @variables['order_date']
    @order.order_location = @variables['order_location']

    url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{@process_instance_id}/steps"
    @steps = JSON.parse(RestClient.get(url))
  end

  def update
    process_instance_id = params[:process][:process_instance_id]
    task_id = params[:process][:task_id]
    url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{process_instance_id}/completeTask/#{task_id}"
    begin
      response = RestClient.patch(url, params[:order].to_json, :content_type => 'application/json')

      if response.instance_values['code'].between?(200, 207)
        redirect_to root_path, notice: "#{format('Successfully completed ', ORDER_SUBMIT_TASK_NAME)} step."
      else
        @error = 'Unable to submit order'
        redirect_to edit_order_path(process_instance_id, :task_id=> task_id)
      end
    rescue StandardError => e
      @error = "Unable to create new process instance:  #{e.message}"
      redirect_to edit_order_path(process_instance_id, :error => @error)
    end
  end
end
