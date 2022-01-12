class Workflow
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :process_definition_key, :business_key, :active_task_name
  validates :process_definition_key, :business_key, presence: true

end
