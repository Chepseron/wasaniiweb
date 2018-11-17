class MediaController < ApplicationController  
  skip_before_action :require_login, only: [ :media_dashboard,:media_listings]
  helper_method :params

  def media_dashboard
  	@locale = params[:locale] || 'local'
    @request_path = request.path

    #@gallery = GalleryPhoto.viewable.last(4)
    @photoarts = PhotoArt.viewable.last(4)
    #@collections = CollectionAlbum.viewable.last(4)
    #@stories = NewsStory.viewable.last(4)
    @books = Book.viewable.last(4)
    @productions = Production.viewable.last(4)
    @songs = Song.viewable.last(4)

    @category_count = {
      'songs' => Song.published.or(Song.verified).count,
      'productions' => Production.published.or(Production.verified).count,
      'books' => Book.published.or(Book.verified).count,
      'photoarts'=> PhotoArt.published.or(PhotoArt.verified).count,
      
    }
  end

  def media_listings
  	@search_letter = params[:search_letter]
  	@locale = params[:locale] || 'local'
  	@request_path = request.path

    if params[:type].present?
      @industry = params[:industry];
      @items = if @industry == "songs"
        Song.published.or(Song.verified).paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")
      elsif @industry == "Production"
        Production.published.or(Production.verified).paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")
      elsif @industry == "photoarts"
        PhotoArt.published.or(PhotoArt.verified).paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")
      elsif @industry == 'gallery'
        GalleryPhoto.viewable
      elsif @industry == 'collections'
        CollectionAlbum.published.or(CollectionAlbum.verified).paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")
      elsif @industry == 'stories'
        NewsStory.published.or(NewsStory.verified).paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")
      elsif @industry == 'books'
        Book.published.or(Book.verified).paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%") 
      elsif @industry == 'productions'
        Production.published.or(Production.verified).paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")                        
      end 

    else
    	@photoarts = PhotoArt.paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")
      @collections = CollectionAlbum.paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")
      @stories = NewsStory.paginate(:page => params[:page], :per_page => 10).where('title LIKE ?', "#{params[:search_letter]}%")

      render 'media_dashboard'
    end
  end
end