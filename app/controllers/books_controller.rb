class BooksController < ApplicationController
  skip_before_action :require_login, only: [:show, :literature_dashboard]
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book.impressions.create!
    
    @description = ActionView::Base.full_sanitizer.sanitize(@book.summary).split(/\s+/).slice(0,300).join(' ');
  end

  # GET /books/new
  def new
    @book = @parent.books.build
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = @parent.books.build(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        @artist = @book.parent
        @id = "book-#{@book.id}"
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
        format.js { render :update}
      else
        format.html { render :edit }
        format.js { render partial: 'shared/errors', locals: {entity: @book} }
      end
    end
  end

  def literature_dashboard
    @industry_name = "Literature"
    @locale = params[:locale] || 'local'
    @request_path = request.path

    @artists = if @locale == 'local' && current_user
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true).where(country_of_birth: current_user.country)
    else
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true)
    end
    @specialities = Industry.find_by_name(@industry_name).artist_specialities.pluck(:name)

    @trending_artists = if @locale == 'local' && current_user
      Artist.viewable.trending_in_literature.collect{|artist| artist if artist.country_of_birth == current_user.country}.compact
    else
      Artist.viewable.trending_in_literature
    end

    @events = if @locale == 'local' && current_user
      Industry.find_by_name(@industry_name).events.viewable.collect do |event|
        event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name
      end.compact
    else
      Industry.find_by_name(@industry_name).events.viewable
    end

    render 'shared/entity_dashboard'
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_publishing_companies
    publishing_companies = Business.where('name ILIKE ?', "%#{params[:term]}%")
    render :json => publishing_companies.map { |publishing_company| {:id => publishing_company.id, :label => publishing_company.name, :value => publishing_company.name} }
  end

  def token_inputs
    if params[:artist_id]
      artist = Artist.find(params[:artist_id])
      render :json => artist.books.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    else
      render :json => Book.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.friendly.find(params[:id])
    end



    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :isbn, :cover_pic, :retained_cover_pic,
      :summary, :parent_id, :parent_type, :country, :publishing_company_name, :publishing_date)
    end
end
