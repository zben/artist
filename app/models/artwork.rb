# encoding: utf-8
class Artwork
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers
  include SimpleEnum::Mongoid
  include Mongoid::Slug

  has_many :photos, autosave: true, dependent: :destroy, as: :attachable
  has_many :orders
  has_many :bookmarkings,:class_name=>"Bookmark", as: :bookmarkable
  belongs_to :ind_user

  field :title
  slug :title, history: true
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
  field :for_sale, type: Boolean, default: true
  field :ready, type: Boolean, default: false
  field :disabled_at, type: DateTime
  field :real_order_count, default: 0
  field :copy_order_count, default: 0
  field :likes_counter, default: 0
  field :visit_counter, default: 0
  as_enum :status,
    :nothing => 0, :asked => 1, :placed => 2, :cancelled => 3, :paid => 4, :shipped => 5, :delivered => 6
  auto_increment :number, seed: 1000

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

  default_scope self.where(disabled_at: nil).desc(:created_at)
  scope :ready, where(ready: true).where(:status_cd.in => [nil, 0, 1, 2, 3])
  scope :not_ready, where(ready: false).where(:status_cd.in => [nil, 0, 1, 2, 3])

  before_save :update_price_timestamps
  before_save :update_readiness

  def update_readiness
    self.ready = (self.info_complete? && self.for_sale)
    nil
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
      "暂缺"
    end
  end

  def price_out_of_date
    self.price_updated_at.to_i >= self.sale_price_updated_at.to_i
  end

  def real_ordered_by user
    orders.where(org_user_id: user.id, is_for_real: true).present?
  end

  def copy_ordered_by user
    orders.where(org_user_id: user.id, is_for_real: false).present?
  end

  def info_complete?
    [:price,:height,:width, :weight, :is_framed, :title, :type, :base, :year].all? do |p|
      !self.send(p).nil?
    end
  end

  def self.find slug_or_id
    self.find_by_slug(slug_or_id) || self.where(_id: slug_or_id).try(:first)
  end
end
