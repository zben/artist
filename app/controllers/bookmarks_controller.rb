class BookmarksController < ApplicationController
  def bookmark
    @bookmarks = current_user.bookmarks.where(:bookmarkable_type=>params[:type]).where(:bookmarkable_id=>params[:id])
    if @bookmarks.empty?
      p params[:type]
      p params[:id]
      p Artwork.find(params[:id])
      p Artwork.find("50905c43421aa98a9300001a")
      @bookmark = Bookmark.create(:user_id=>current_user.id,:bookmarkable=>eval(params[:type]).find(params[:id]))
      @is_bookmarked = true
    else
      @bookmark = @bookmarks.first
      @bookmarks.destroy_all
      @is_bookmarked = false
    end
    p @bookmark
    @bookmarkable = @bookmark.bookmarkable
    
    respond_to do |format|  
      format.js    
    end  
  end

end
