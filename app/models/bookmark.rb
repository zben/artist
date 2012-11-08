class Bookmark
  include Mongoid::Document

  belongs_to :bookmarkable, polymorphic: true
  belongs_to :user

  after_create :increment_bookmark_counter
  after_destroy :decrement_bookmark_counter

  def increment_bookmark_counter
    bookmarkable.inc(:likes_counter, 1) if bookmarkable.respond_to?(:likes_counter)
  end

  def decrement_bookmark_counter
    bookmarkable.inc(:likes_counter, -1) if bookmarkable.respond_to?(:likes_counter) && bookmarkable.likes_counter>1
  end
end
