class ItemSourcesController < ApplicationController
  before_action :set_item_source, only: %i[ show edit update destroy ]

  # GET /item_sources or /item_sources.json
  def index
    @item_sources = ItemSource.all
  end

  # GET /item_sources/1 or /item_sources/1.json
  def show
  end

  # GET /item_sources/new
  def new
    @item_source = ItemSource.new
  end

  # GET /item_sources/1/edit
  def edit
  end

  # POST /item_sources or /item_sources.json
  def create
    @item_source = ItemSource.new(item_source_params)

    respond_to do |format|
      if @item_source.save
        format.html { redirect_to item_source_url(@item_source), notice: "Item source was successfully created." }
        format.json { render :show, status: :created, location: @item_source }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_sources/1 or /item_sources/1.json
  def update
    respond_to do |format|
      if @item_source.update(item_source_params)
        format.html { redirect_to item_source_url(@item_source), notice: "Item source was successfully updated." }
        format.json { render :show, status: :ok, location: @item_source }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_sources/1 or /item_sources/1.json
  def destroy
    @item_source.destroy

    respond_to do |format|
      format.html { redirect_to item_sources_url, notice: "Item source was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_source
      @item_source = ItemSource.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_source_params
      params.require(:item_source).permit(:item_id, :source_id, :source_type, :stars)
    end
end
