class TerrainsController < ApplicationController
  before_action :set_terrain, only: %i[ show edit update destroy ]

  # GET /terrains or /terrains.json
  def index
    @terrains = Terrain.all
  end

  # GET /terrains/1 or /terrains/1.json
  def show
  end

  # GET /terrains/new
  def new
    @terrain = Terrain.new
  end

  # GET /terrains/1/edit
  def edit
  end

  # POST /terrains or /terrains.json
  def create
    @terrain = Terrain.new(terrain_params)

    respond_to do |format|
      if @terrain.save
        format.html { redirect_to terrain_url(@terrain), notice: "Terrain was successfully created." }
        format.json { render :show, status: :created, location: @terrain }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @terrain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /terrains/1 or /terrains/1.json
  def update
    respond_to do |format|
      if @terrain.update(terrain_params)
        format.html { redirect_to terrain_url(@terrain), notice: "Terrain was successfully updated." }
        format.json { render :show, status: :ok, location: @terrain }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @terrain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terrains/1 or /terrains/1.json
  def destroy
    @terrain.destroy

    respond_to do |format|
      format.html { redirect_to terrains_url, notice: "Terrain was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terrain
      @terrain = Terrain.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def terrain_params
      params.require(:terrain).permit(:name)
    end
end
