class BlogsController < ApplicationController
  skip_before_action :require_login, only: :show
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @blog.impressions.create!
    @description = ActionView::Base.full_sanitizer.sanitize(@blog.content).split(/\s+/).slice(0,300).join(' ');
  end

  # GET /blogs/new
  def new
    @blog = @parent.blogs.build
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = @parent.blogs.build(blog_params)

    respond_to do |format|
      if @blog.save
        add_gallery_photos(@blog, params[:images]) if params[:images]
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        @id = "blog-#{@blog.id}"
        @artist = @blog.parent
        add_gallery_photos(@blog, params[:images]) if params[:images]
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
        format.js {render :update}
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :date, :content, :parent_id, :image, :retained_image,
      :parent_type, :artist_id_tags, :business_id_tags, :event_id_tags, :award_id_tags)
    end
end
