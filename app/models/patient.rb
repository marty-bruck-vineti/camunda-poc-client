class Patient
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name
  attr_reader :full_name

  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: 'Only letters allowed' }

  def full_name
    %i[first_name last_name].join(' ');
  end
end
