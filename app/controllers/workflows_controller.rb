require 'rest-client'
class WorkflowsController < ApplicationController

  @@base_url = 'http://localhost:8080/api/v1/'
  @@process_instance_path = 'processinstance/'
  @@process_definition_path = 'processdefinition/'

  before_action :check_for_cancel, only: [:create]

  def check_for_cancel
    if params[:commit].eql?("Cancel")
      redirect_to root_path
    end
  end

  def index
    # TODO: Add to config
    url = @@base_url + @@process_instance_path
    response = RestClient.get(url)
    @instances = JSON.parse(response.body)
    print response.code
  end

  def new
    url = @@base_url + @@process_definition_path
    response = RestClient.get(url)
    @processes = JSON.parse(response.body)
    @error = nil
    @workflow = Workflow.new
  end

  def create
    @workflow = Workflow.new(params[:workflow].as_json)
    if (@workflow.valid?)
      url = @@base_url + @@process_instance_path + 'create/' + @workflow.process_definition_key + "/" + @workflow.business_key
      response = RestClient.post(url, nil)
      begin
        if (response.instance_values["code"].between?(200,207))
          redirect_to root_url, notice: "Successfully created new process instance"
        else
          @error = 'Unable to create'
        end
      rescue Exception => e
        @error = 'Unable to create new process instance:  ' + 'e.message'
      end
    else
      url = @@base_url + @@process_definition_path
      response = RestClient.get(url)
      @processes = JSON.parse(response.body)
      render new_workflow_path
    end

  end

end