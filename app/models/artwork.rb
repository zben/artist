# encoding: utf-8
class Artwork
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers
  include SimpleEnum::Mongoid
  include Mongoid::Slug

  has_many :photos, autosave: true, dependent: :destroy, as: :attachable
  has_many :sellables
  has_many :bookmarkings,:class_name=>"Bookmark", as: :bookmarkable
  belongs_to :ind_user, index: true
  belongs_to :theme, index: true
  field :title
  field :description
  as_enum :type, oil: 1, pastel: 2, acrylic: 3, watercolor: 4, ink: 5, spray: 6, pencil: 7, other: 8
  field :year

  field :likes_counter, default: 0
  field :visit_counter, default: 0

  field :original_available, type: Boolean, default: false
  field :copy_available, type: Boolean, default: false
  field :for_display, type: Boolean, default: false

  field :original_price, type: Integer
  field :original_sale_price, type: Integer

  field :copy_price, type: Integer
  field :copy_sale_price, type: Integer

  slug :title, reserve: [""], history: true

  index :title, background: true
  index :type, background: true
  index :likes_counter, background: true
  index :visit_counter, background: true
  index :original_avaiable, background: true
  index :copy_available, background: true
  index :for_display, background: true
  index :original_sale_price, background: true
  index :copy_sale_price, background: true

  accepts_nested_attributes_for :photos, allow_destroy: true

  default_scope desc(:_id)
  scope :ready, where(for_display: true)
  scope :not_ready, where(for_display: false)


  before_save :update_availability

  def update_availability
    original = self.sellables.where(is_original: true).where(for_sale: true).first
    copy = self.sellables.where(is_original: false).where(for_sale: true).first

    if original
      self.original_price = original.price
      self.original_sale_price = original.sale_price
      self.original_available = true
    else
      self.original_available = false
    end

    if copy
      self.copy_price = copy.price
      self.copy_sale_price = copy.sale_price
      self.copy_available = true
    else
      self.copy_available = false
    end

    self.for_display = self.original_available || self.copy_available
    nil
  end


  def self.find slug_or_id
    self.find_by_slug(slug_or_id) || self.where(_id: slug_or_id).try(:first)
  end

  def previous
    ind_user.artworks.ready.where(:_id.lt => self._id).first || ind_user.artworks.ready.first
  end

  def next
    ind_user.artworks.ready.where(:_id.gt => self._id).last || ind_user.artworks.ready.last
  end
end
