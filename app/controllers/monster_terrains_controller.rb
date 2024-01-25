class MonsterTerrainsController < ApplicationController
  before_action :set_monster_terrain, only: %i[ show edit update destroy ]

  # GET /monster_terrains or /monster_terrains.json
  def index
    @monster_terrains = MonsterTerrain.all
  end

  # GET /monster_terrains/1 or /monster_terrains/1.json
  def show
  end

  # GET /monster_terrains/new
  def new
    @monster_terrain = MonsterTerrain.new
  end

  # GET /monster_terrains/1/edit
  def edit
  end

  # POST /monster_terrains or /monster_terrains.json
  def create
    @monster_terrain = MonsterTerrain.new(monster_terrain_params)

    respond_to do |format|
      if @monster_terrain.save
        format.html { redirect_to monster_terrain_url(@monster_terrain), notice: "Monster terrain was successfully created." }
        format.json { render :show, status: :created, location: @monster_terrain }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @monster_terrain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monster_terrains/1 or /monster_terrains/1.json
  def update
    respond_to do |format|
      if @monster_terrain.update(monster_terrain_params)
        format.html { redirect_to monster_terrain_url(@monster_terrain), notice: "Monster terrain was successfully updated." }
        format.json { render :show, status: :ok, location: @monster_terrain }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @monster_terrain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monster_terrains/1 or /monster_terrains/1.json
  def destroy
    @monster_terrain.destroy

    respond_to do |format|
      format.html { redirect_to monster_terrains_url, notice: "Monster terrain was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monster_terrain
      @monster_terrain = MonsterTerrain.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def monster_terrain_params
      params.require(:monster_terrain).permit(:monster_id, :terrain_id)
    end
end
