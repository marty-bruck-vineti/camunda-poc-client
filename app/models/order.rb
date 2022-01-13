class Order
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :order_date, :order_location

  validates :order_date, presence: true
  validates_presence_of :order_location

end
