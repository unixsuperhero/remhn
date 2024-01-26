class ItemStatsController < ApplicationController
  before_action :set_item_stat, only: %i[ show edit update destroy ]

  # GET /item_stats or /item_stats.json
  def index
    @item_stats = ItemStat.all
  end

  # GET /item_stats/1 or /item_stats/1.json
  def show
  end

  # GET /item_stats/new
  def new
    @item_stat = ItemStat.new
  end

  # GET /item_stats/1/edit
  def edit
  end

  # POST /item_stats or /item_stats.json
  def create
    @item_stat = ItemStat.new(item_stat_params)

    respond_to do |format|
      if @item_stat.save
        format.html { redirect_to item_stat_url(@item_stat), notice: "Item stat was successfully created." }
        format.json { render :show, status: :created, location: @item_stat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_stats/1 or /item_stats/1.json
  def update
    respond_to do |format|
      if @item_stat.update(item_stat_params)
        format.html { redirect_to item_stat_url(@item_stat), notice: "Item stat was successfully updated." }
        format.json { render :show, status: :ok, location: @item_stat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_stats/1 or /item_stats/1.json
  def destroy
    @item_stat.destroy

    respond_to do |format|
      format.html { redirect_to item_stats_url, notice: "Item stat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_stat
      @item_stat = ItemStat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_stat_params
      params.require(:item_stat).permit(:item_id, :equipable_stat_id, :qty)
    end
end
