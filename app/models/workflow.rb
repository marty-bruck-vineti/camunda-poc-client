class Workflow
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :process_definition_name, :business_key, :id, :current_task_dto
  validates :process_definition_name, :business_key, presence: true

end
