class WeaknessesController < ApplicationController
  before_action :set_weakness, only: %i[ show edit update destroy ]

  # GET /weaknesses or /weaknesses.json
  def index
    @weaknesses = Weakness.all
  end

  # GET /weaknesses/1 or /weaknesses/1.json
  def show
  end

  # GET /weaknesses/new
  def new
    @weakness = Weakness.new
  end

  # GET /weaknesses/1/edit
  def edit
  end

  # POST /weaknesses or /weaknesses.json
  def create
    @weakness = Weakness.new(weakness_params)

    respond_to do |format|
      if @weakness.save
        format.html { redirect_to weakness_url(@weakness), notice: "Weakness was successfully created." }
        format.json { render :show, status: :created, location: @weakness }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @weakness.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weaknesses/1 or /weaknesses/1.json
  def update
    respond_to do |format|
      if @weakness.update(weakness_params)
        format.html { redirect_to weakness_url(@weakness), notice: "Weakness was successfully updated." }
        format.json { render :show, status: :ok, location: @weakness }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @weakness.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weaknesses/1 or /weaknesses/1.json
  def destroy
    @weakness.destroy

    respond_to do |format|
      format.html { redirect_to weaknesses_url, notice: "Weakness was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weakness
      @weakness = Weakness.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def weakness_params
      params.require(:weakness).permit(:monster_id, :element_id)
    end
end
