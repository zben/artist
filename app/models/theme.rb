class Theme
  include Mongoid::Document
  field :name_ch
  field :name_en


  has_many :artworks


  def self.populate
    %w{Abstract Animals Architecture Fantasy
      Floral Food/Beverage Impressionism Landmarks
      Landscapes Nudes Portraits Science-Fiction
      Seascape Skylines/Urban/Cities Sports Still
      Life Surrealism Other}.each do |theme|

      self.create(name_ch: theme, name_en: theme)
    end
  end


end
