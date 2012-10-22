# encoding: utf-8
class Artwork
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :photos, autosave: true, dependent: :destroy, as: :attachable
  belongs_to :ind_user
  field :title
  field :description
  field :type
  field :base
  field :year
  field :price, type: Integer
  field :price_updated_at, type: DateTime
  field :sale_price, type: Integer
  field :sale_price_updated_at, type: DateTime
  field :height, type: Integer
  field :width, type: Integer
  field :is_framed, type: Boolean
  field :weight, type: Float

  PAINTING_TYPES = %w{
    Oil
    Pastel
    Acrylic
    Watercolor
    Ink
    Sprary Paint
    Other
  }
  accepts_nested_attributes_for :photos, allow_destroy: true

  default_scope self.desc(:created_at)

  before_save :update_price_timestamps

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
    yuan = (price * 6.3)
    rounded = yuan.round(-2) -1
  end

  def price_in_yuan(original=true)
    if sale_price
      "¥#{sale_price}"
    else
      "暂缺"
    end
  end

  def price_out_of_date
    self.price_updated_at.to_i >= self.sale_price_updated_at.to_i
  end
end
