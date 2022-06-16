class CategoriesController < ApplicationController
  skip_before_action :protect_pages, only: [:index, :show]

  # GET /categories or /categories.json
  def index
    @categories = Category.all.order(name: :asc) #ordenamos alfabeticamente
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    category
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)


    #debido a que solo necesitaremos responder a html, modificamos el redirect de la siguiente forma
    if @category.save
      redirect_to categories_url, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update

    #debido a que solo necesitaremos responder a html, modificamos el redirect de la siguiente forma
    if category.update(category_params)
      redirect_to categories_url, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end

  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url, notice: t('.destroyed') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #cambiamos el before_action :set_category por category y eliminamos el before_action
    def category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    end
end
