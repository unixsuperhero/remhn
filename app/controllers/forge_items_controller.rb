class ForgeItemsController < ApplicationController
  before_action :set_forge_item, only: %i[ show edit update destroy ]

  # GET /forge_items or /forge_items.json
  def index
    @forge_items = ForgeItem.all
  end

  # GET /forge_items/1 or /forge_items/1.json
  def show
  end

  # GET /forge_items/new
  def new
    @forge_item = ForgeItem.new
  end

  # GET /forge_items/1/edit
  def edit
  end

  # POST /forge_items or /forge_items.json
  def create
    @forge_item = ForgeItem.new(forge_item_params)

    respond_to do |format|
      if @forge_item.save
        format.html { redirect_to forge_item_url(@forge_item), notice: "Forge item was successfully created." }
        format.json { render :show, status: :created, location: @forge_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @forge_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forge_items/1 or /forge_items/1.json
  def update
    respond_to do |format|
      if @forge_item.update(forge_item_params)
        format.html { redirect_to forge_item_url(@forge_item), notice: "Forge item was successfully updated." }
        format.json { render :show, status: :ok, location: @forge_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @forge_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forge_items/1 or /forge_items/1.json
  def destroy
    @forge_item.destroy

    respond_to do |format|
      format.html { redirect_to forge_items_url, notice: "Forge item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forge_item
      @forge_item = ForgeItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def forge_item_params
      params.require(:forge_item).permit(:equipable_id, :level_id, :item_id, :qty)
    end
end
