class IndUser < User
    include Mongoid::BasicSearch
    has_many :bookmarks, :foreign_key=>"user_id"
    has_many :bookmarkings, :class_name=>"Bookmark", as: :bookmarkable
    has_many :tech_applications
    has_and_belongs_to_many :industries
    scope :with_ind_profile, where(:profile.ne=>nil)
    has_many :artworks, autosave: true, dependent: :destroy
    field :visit_counter, default: 0
  accepts_nested_attributes_for :educations,:allow_destroy => true
  accepts_nested_attributes_for :experiences,:allow_destroy => true
  accepts_nested_attributes_for :exams,:allow_destroy => true
  accepts_nested_attributes_for :languages,:allow_destroy => true
  accepts_nested_attributes_for :profile,:allow_destroy => true
  accepts_nested_attributes_for :org_profile,:allow_destroy => true
  accepts_nested_attributes_for :usage,:allow_destroy => true
  accepts_nested_attributes_for :artworks, :allow_destroy => true

  perform_search_on :profile=>[:name,:intro,:intro_title],
    :educations=>[:degree_type,:school,:program,:comment],
    :experiences=>[:company_name, :job_title, :description,:industry],
    :skills=>[:name_en,:name_ch]

    include Mongoid::Paperclip
    if Rails.env.production?  
      has_mongoid_attached_file :avatar,
        :path => ':avatar/:id/:style.:extension',
        :default_url => '/assets/avatars/:style/missing.png',
        :storage => :s3,
        :bucket => 'artist-benzhang',
        :s3_credentials => {:access_key_id => ENV['S3_KEY'],:secret_access_key => ENV['S3_SECRET']},
        :styles => {
          :original => ['1920x1680>', :jpg],
          :small    => ['30x30#',   :jpg],
          :medium   => ['70x70#',    :jpg],
          :large    => ['150x150#',   :jpg]
        }
    else
      has_mongoid_attached_file :avatar,
        :default_url => 'avatars/:style/missing.png',

        :styles => {
          :original => ['1920x1680>', :jpg],
          :small    => ['30x30#',   :jpg],
          :medium   => ['70x70#',    :jpg],
          :large    => ['150x150#',   :jpg]
        }
    end

  def steps
    %w{profile education exam language experience skill}
  end

  def next_step step
    steps[steps.index(step)+1]
  end

  def prev_step step
    steps[steps.index(step)-1]
  end

  def matching_companies
    OrgUser.all
  end

  def post_process params
    self.update_attributes(chinese_resume: nil) if params[:_destroy_chinese_resume]
    self.update_attributes(english_resume: nil) if params[:_destroy_english_resume]
  end

  def get_job_application job_post
    job_applications.where(:job_post_id=>job_post.id).first
  end

  def job_applied? job_post 
    job_applications.where(:job_post_id=>job_post.id)!=[]
  end

end
