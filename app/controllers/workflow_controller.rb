require 'rest-client'
class WorkflowController < ApplicationController

  def index
    # TODO: Add to config
    url = 'http://localhost:8080/api/v1/processinstance'
    response = RestClient.get(url)
    @instances = JSON.parse(response.body)
  end

  def new
    url = 'http://localhost:8080/api/v1/processdefinition/'
    response = RestClient.get(url)
    @processes = JSON.parse(response.body)
  end

end