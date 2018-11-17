class Admin::BooksController < Admin::AdminController
  before_action :set_book, only: [:show, :change_status]

  def index
    @books = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      artists.map(&:books).flatten
    else
      Book.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @book.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @book]), notice: 'Book was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @book }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @book }}
        else
          format.html { redirect_to polymorphic_path([:admin, @book]), notice: 'Book was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @book }
          format.js {render partial: 'shared/errors', locals: {entity: @book }}
        end
      when 'publish'
        if @book.approve!
          format.html { redirect_to polymorphic_path([:admin, @book]), notice: 'Book was successfully edited.' }
          format.json { render :show, status: :ok, location: @book }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @book }}
        else
          format.html { redirect_to polymorphic_path([:admin, @book]), notice: 'Book was not successfully edited.' }
          format.json { render :show, status: :ok, location: @book }
          format.js {render partial: 'shared/errors', locals: {entity: @book }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @book]), notice: 'Book was not successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
        format.js {render partial: 'shared/errors', locals: {entity: @book }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.friendly.find(params[:id])
    end
end
