class EquipableStatsController < ApplicationController
  before_action :set_equipable_stat, only: %i[ show edit update destroy ]

  # GET /equipable_stats or /equipable_stats.json
  def index
    @equipable_stats = EquipableStat.all
  end

  # GET /equipable_stats/1 or /equipable_stats/1.json
  def show
  end

  # GET /equipable_stats/new
  def new
    @equipable_stat = EquipableStat.new
  end

  # GET /equipable_stats/1/edit
  def edit
  end

  # POST /equipable_stats or /equipable_stats.json
  def create
    @equipable_stat = EquipableStat.new(equipable_stat_params)

    respond_to do |format|
      if @equipable_stat.save
        format.html { redirect_to equipable_stat_url(@equipable_stat), notice: "Equipable stat was successfully created." }
        format.json { render :show, status: :created, location: @equipable_stat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @equipable_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipable_stats/1 or /equipable_stats/1.json
  def update
    respond_to do |format|
      if @equipable_stat.update(equipable_stat_params)
        format.html { redirect_to equipable_stat_url(@equipable_stat), notice: "Equipable stat was successfully updated." }
        format.json { render :show, status: :ok, location: @equipable_stat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @equipable_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipable_stats/1 or /equipable_stats/1.json
  def destroy
    @equipable_stat.destroy

    respond_to do |format|
      format.html { redirect_to equipable_stats_url, notice: "Equipable stat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipable_stat
      @equipable_stat = EquipableStat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def equipable_stat_params
      params.require(:equipable_stat).permit(:grade, :sub_grade, :atk, :crit, :elem, :def, :forge, :equipable_id)
    end
end
