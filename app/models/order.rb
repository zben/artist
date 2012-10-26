class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid


  belongs_to :artwork
  belongs_to :org_user

  field :comment
  field :is_for_real, type: Boolean, default: true
  as_enum :status, :placed => 0, :cancelled => 1, :paid => 2, :shipped => 3, :delivered => 4
  field :payment, type: Float
  field :quantity, type: Integer, default: 1
  field :address
  field :shipping_number
  field :shipping_company
  field :receipt_date, type: DateTime
  auto_increment :number, seed: 1000

  default_scope desc(:created_at)

  after_save :update_artwork

  def update_artwork
    if self.status == :paid
      artwork.update_attribute :sold, true
    end
  end
end
