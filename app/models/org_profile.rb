# encoding: UTF-8
class OrgProfile
  include Mongoid::Document
  include Mongoid::Timestamps

    
  field :company_name
  field :short_description
  field :long_description

  include SimpleEnum::Mongoid
  

  as_enum :people_count, :"1-10人"=>1, :"11-50人"=>2, :"51-200人"=>3, :"201-500人"=>4, :"501-1000人"=>5,
   :"1001-5000人"=>6, :"5001-10000人"=>7, :"10000人以上"=>8
  field :contact_person
  field :phone_number
  field :email
  field :website
  field :address
  as_enum :company_type, :"国企"=>1, :"民企"=>2, :"外企"=>3, :"非营利组织"=>4, :"学术研究机构"=>5

  belongs_to :industry
  belongs_to :province
  field :province_id, type: Integer
  belongs_to :city
  field :city_id, type: Integer
  embedded_in :user
#  field :city_id, type: Integer
#  field :province_id, type: Integer
#  field :industry_id, type: Integer

  validates :contact_person,:phone_number, :province_id, :presence=>true

  after_save :update_user_full_name

  def update_user_full_name
    user.update_attribute :full_name, self.name
  end

  def name
    contact_person
  end
end
