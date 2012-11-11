# encoding: UTF-8
class Profile 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include SimpleEnum::Mongoid
  include Mongoid::Search

  as_enum :gender, :"Female" => 1, :"Male" => 0

  field :firstname
  field :lastname
  field :birthday, type: Date
  field :citizenship, type: Integer
  field :residence_country, type: Integer
  field :city
  field :residence_state, type: Integer
  field :intro
  field :intro_title
  field :phone
  field :website
  field :gallery
  field :address
  field :intro_ch
#  has_mongoid_attached_file :avatar,
#  :styles => {
#    :original => ['1920x1680>', :jpg],
#    :thumb    => ['100x100',   :jpg],
#    :medium   => ['200x150',    :jpg]

#  }

  validates :firstname, :lastname, :birthday, :gender, :province_id, :phone, :city, :province_id, :presence=>true
  #validates :intro, :intro_title, :presence=>true
  validates_length_of :firstname, :maximum => 20
  validates_length_of :lastname, :maximum => 20
  embedded_in :user
  belongs_to :province
  field :province_id, type: Integer

  after_save :update_user_full_name

  def update_user_full_name
    user.update_attribute :full_name, self.name
  end

  def name
    firstname + " " + lastname
  end

  def nationality
      Country.find(citizenship).name
  end

  def residence
      Country.find(residence_country).name
  end

  def age
    now = Time.now.utc.to_date
    now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def citystate
    (self.city || "Unknown") + ", " + self.province.name[0..3]
  end

  def full_location
    (self.city || "Unknown") + ", " + self.province.name + ", " + self.province.country.name
  end
end
