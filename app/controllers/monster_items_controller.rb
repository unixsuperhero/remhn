class MonsterItemsController < ApplicationController
  before_action :set_monster_item, only: %i[ show edit update destroy ]

  # GET /monster_items or /monster_items.json
  def index
    @monster_items = MonsterItem.all
  end

  # GET /monster_items/1 or /monster_items/1.json
  def show
  end

  # GET /monster_items/new
  def new
    @monster_item = MonsterItem.new
  end

  # GET /monster_items/1/edit
  def edit
  end

  # POST /monster_items or /monster_items.json
  def create
    @monster_item = MonsterItem.new(monster_item_params)

    respond_to do |format|
      if @monster_item.save
        format.html { redirect_to monster_item_url(@monster_item), notice: "Monster item was successfully created." }
        format.json { render :show, status: :created, location: @monster_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @monster_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monster_items/1 or /monster_items/1.json
  def update
    respond_to do |format|
      if @monster_item.update(monster_item_params)
        format.html { redirect_to monster_item_url(@monster_item), notice: "Monster item was successfully updated." }
        format.json { render :show, status: :ok, location: @monster_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @monster_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monster_items/1 or /monster_items/1.json
  def destroy
    @monster_item.destroy

    respond_to do |format|
      format.html { redirect_to monster_items_url, notice: "Monster item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monster_item
      @monster_item = MonsterItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def monster_item_params
      params.require(:monster_item).permit(:monster_id, :item_id, :grade)
    end
end
