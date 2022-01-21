# frozen_string_literal: true

##
#
class PatientsController < ApplicationController
  PATIENT_TASK_NAME = 'add_patient_demographics'
  BASE_URL = 'http://localhost:8080/api/v1/'
  PROCESS_INSTANCE_PATH = 'processinstance/'

  before_action :check_for_cancel, only: [:create]

  def check_for_cancel
    redirect_to root_path if params[:commit].eql?('Cancel')
  end
  def get_step_list (process_instance_id)
    url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{process_instance_id}/steps"
    @steps = JSON.parse(RestClient.get(url))
  end

  def new
    @patient = Patient.new
    @process_instance_id = params[:process_instance_id]
    @task_id = params[:task_id]
    get_step_list @process_instance_id
  end

  ##
  # retrieve and validate the patient demographics. If ok, mark this task as complete
  def create
    @patient = Patient.new(params[:patient].as_json)
    @process_instance_id = params[:process][:process_instance_id]
    @task_id = params[:process][:task_id]
    get_step_list @process_instance_id

    if @patient.valid?
      url = "#{BASE_URL}#{PROCESS_INSTANCE_PATH}#{params[:process][:process_instance_id]}/completeTask/#{params[:process][:task_id]}"
      begin
        response = RestClient.patch(url, params[:patient].to_json, :content_type => 'application/json')

        if response.instance_values['code'].between?(200, 207)
          redirect_to root_url, notice: "#{format('Successfully completed ', PATIENT_TASK_NAME)} step."
        else
          @error = 'Unable to create'
          render new_patient_path
        end
      rescue StandardError => e
        @error = "Unable to create new process instance:  #{e.message}"
        render new_patient_path
      end
    else
      render new_patient_path
    end
  end

  # use this method to route to the specific update screen (e.g. add_patient_demographics, create_order, etc.)
  # input is the selected workflow
  def update
    workflow = Workflow.new(p)
  end
end
