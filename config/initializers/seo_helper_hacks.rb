module ActionView
  module Helpers
    alias_method :original_image_tag, :image_tag
    def image_tag(source, options={})
      original_image_tag(source, options.merge(alt: "Sell artworks, paintings to China | canvvas"))
    end

    alias_method :original_time_ago_in_words, :time_ago_in_words
    def time_ago_in_words(source)
      result = original_time_ago_in_words(source)
      result.slice! "less than"
      result.slice! "about"
      result
    end
  end
end

