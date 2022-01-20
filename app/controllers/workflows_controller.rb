# frozen_string_literal: true

require 'rest-client'
##
#
class WorkflowsController < ApplicationController
  BASE_URL = 'http://localhost:8080/api/v1/'
  PROCESS_INSTANCE_PATH = 'processinstance/'
  PROCESS_DEFINITION_PATH = 'processdefinition/'

  before_action :check_for_cancel, only: [:create]

  def check_for_cancel
    redirect_to root_path if params[:commit].eql?('Cancel')
  end

  def index
    # TODO: Add to config
    url = BASE_URL + PROCESS_INSTANCE_PATH
    response = RestClient.get(url)
    @workflows = JSON.parse(response.body)
  end

  def new
    url = BASE_URL + PROCESS_DEFINITION_PATH
    response = RestClient.get(url)
    @processes = JSON.parse(response.body)
    @error = nil
    @workflow = Workflow.new
  end

  def create
    @workflow = Workflow.new(params[:workflow].as_json)
    if @workflow.valid?
      url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}create/#{@workflow.process_definition_name}/#{@workflow.business_key}"
      response = RestClient.post(url, nil)
      begin
        if response.instance_values['code'].between?(200, 207)
          redirect_to root_url, notice: 'Successfully created new process instance'
        else
          @error = 'Unable to create'
        end
      rescue StandardError => e
        @error = "Unable to create new process instance:  #{e.message}"
      end
    else
      url = BASE_URL + PROCESS_DEFINITION_PATH
      response = RestClient.get(url)
      @processes = JSON.parse(response.body)
      render new_workflow_path
    end
  end
  def edit
    case params[:task_id]
    when 'add_patient_demographics'
      redirect_to new_patient_path(:process_instance_id => params[:id], :task_id=> params[:task_id])
    when 'create_order'
      redirect_to new_order_path(:process_instance_id => params[:id], :task_id=> params[:task_id])
    when 'submit_order', 'send_order_to_us', 'send_order_to_europe'
      redirect_to edit_order_path(params[:id], :task_id=> params[:task_id])

    else
      render new_workflow_path
    end
  end

  def destroy
    url = BASE_URL + PROCESS_INSTANCE_PATH + params[:id]
    RestClient.delete(url)
    redirect_to root_url, notice: 'Successfully cancelled  process instance'
  end
end
