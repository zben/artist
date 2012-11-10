# encoding: utf-8
class Artwork
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers
  include SimpleEnum::Mongoid
  include Mongoid::Paranoia
  include Mongoid::Slug

  has_many :photos, autosave: true, dependent: :destroy, as: :attachable
  has_many :sellables, autosave: true
  has_many :bookmarkings,:class_name=>"Bookmark", as: :bookmarkable
  belongs_to :ind_user

  field :title
  slug :title, history: true
  field :description
  field :type
  field :base
  field :year

  field :likes_counter, default: 0
  field :visit_counter, default: 0

  field :original_available, type: Boolean, default: false
  field :copy_available, type: Boolean, default: false
  field :for_display, type: Boolean, default: false

  PAINTING_TYPES = %w{ Oil Pastel Acrylic Watercolor Ink Sprary Paint Other }

  accepts_nested_attributes_for :photos, allow_destroy: true

  default_scope desc(:created_at)
  scope :ready, where(for_display: true)
  scope :not_ready, where(for_display: false)

  before_save :update_availability

  def update_availability
    self.original_available =
      self.sellables.where(is_original: true).where(for_sale: true).exists?
    self.copy_available =
      self.sellables.where(is_original: false).where(for_sale: true).exists?
    self.for_display = self.original_available || self.copy_available
  end


  def self.find slug_or_id
    self.find_by_slug(slug_or_id) || self.where(_id: slug_or_id).try(:first)
  end
end
