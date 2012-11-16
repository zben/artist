module ActionView
  module Helpers
    alias_method :original_image_tag, :image_tag
    def image_tag(source, options={})
      original_image_tag(source, options.merge(alt: "Sell artworks, paintings to China | canvvas"))
    end
  end
end

