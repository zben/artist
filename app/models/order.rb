class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid


  belongs_to :sellable
  belongs_to :org_user

  field :comment
  field :is_for_real, type: Boolean, default: true
  as_enum :status, :asked => 0, :placed => 1, :cancelled => 2, :paid => 3, :shipped => 4, :delivered => 5
  field :payment, type: Integer
  field :quantity, type: Integer, default: 1
  field :address
  field :shipping_number
  field :shipping_company
  field :receipt_date, type: DateTime
  auto_increment :number, seed: 1000

  default_scope desc(:created_at)
  scope :active, where(:status_cd.ne => 2)
  scope :real, where(is_for_real: true)
  scope :copy, where(is_for_real: false)
end
