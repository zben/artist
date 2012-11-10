#encoding: utf-8
class Sellable
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid
  include Mongoid::Paranoia
  include ActionView::Helpers

  belongs_to :artwork
  belongs_to :order

  auto_increment :number, seed: 1000
  field :is_original, type: Boolean

  field :price, type: Integer
  field :price_updated_at, type: DateTime
  field :sale_price, type: Integer
  field :sale_price_updated_at, type: DateTime

  field :height, type: Integer
  field :width, type: Integer
  field :is_framed, type: Boolean, default: false
  field :weight, type: Float
  field :note

  field :for_sale, type: Boolean, default: true
  field :ready, type: Boolean, default: false
  field :order_count

  scope :original, where(is_original: true)
  scope :copy, where(is_original: false)


  validates_presence_of :price, :height, :width, :weight

  before_save :update_price_timestamps
  after_save :save_artwork

  def save_artwork
    self.artwork.save
  end

  def update_price_timestamps
    if price_changed?
      self.price_updated_at = Time.now
    end

    if sale_price_changed?
      self.sale_price_updated_at = Time.now
    end

    if sale_price.nil?
      self.sale_price = generate_sale_price
    end
  end

  def generate_sale_price
    yuan = (price.to_i * 6.3)
    with_markup = yuan * 1.5 + 1000
    rounded = with_markup.round(-2) -1
  end

  def copy_default_sale_price
    update_attribute :sale_price, generate_sale_price
  end

  def price_in_yuan(original=true)
    if sale_price
      "¥#{number_with_delimiter(sale_price, delimiter: ',')}"
    else
      "N/A"
    end
  end

  def price_out_of_date
    self.price_updated_at.to_i >= self.sale_price_updated_at.to_i
  end


  def info_complete?
    [:price, :height, :width, :weight, :is_framed].all? do |p|
      !self.send(p).nil?
    end
  end

end
