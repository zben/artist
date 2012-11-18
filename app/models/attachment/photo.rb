# encoding: UTF-8
class Photo < Attachment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip


  if Rails.env.production? || Rails.env.staging?
    has_mongoid_attached_file :photo,
      :path => ':photo/:id/:style.:extension',
      :storage => :s3,
      :bucket => 'canvvas',
      :s3_credentials => {:access_key_id => ENV['S3_KEY'],:secret_access_key => ENV['S3_SECRET']},
      :s3_host_name => "s3-ap-northeast-1.amazonaws.com",
      :styles => {
      :original => ['1920x1680>', :jpg],
      :thumb    => ['100',   :jpg],
      :medium   => ['260',    :jpg],
      :large =>['670', :jpg]
    }
  else
    has_mongoid_attached_file :photo,
      :default_url => '/assets/photo/:style/missing.jpg',
      :styles => {
      :original => ['1920x1680>', :jpg],
      :thumb    => ['100',   :jpg],
      :medium   => ['260',    :jpg],
      :large =>['670', :jpg]
    }
  end


end
