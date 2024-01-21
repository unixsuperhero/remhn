class EquipablesController < ApplicationController
  before_action :set_equipable, only: %i[ show edit update destroy ]

  # GET /equipables or /equipables.json
  def index
    @equipables = Equipable.all
  end

  # GET /equipables/1 or /equipables/1.json
  def show
  end

  # GET /equipables/new
  def new
    @equipable = Equipable.new
  end

  # GET /equipables/1/edit
  def edit
  end

  # POST /equipables or /equipables.json
  def create
    @equipable = Equipable.new(equipable_params)

    respond_to do |format|
      if @equipable.save
        format.html { redirect_to equipable_url(@equipable), notice: "Equipable was successfully created." }
        format.json { render :show, status: :created, location: @equipable }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @equipable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipables/1 or /equipables/1.json
  def update
    respond_to do |format|
      if @equipable.update(equipable_params)
        format.html { redirect_to equipable_url(@equipable), notice: "Equipable was successfully updated." }
        format.json { render :show, status: :ok, location: @equipable }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @equipable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipables/1 or /equipables/1.json
  def destroy
    @equipable.destroy

    respond_to do |format|
      format.html { redirect_to equipables_url, notice: "Equipable was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipable
      @equipable = Equipable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def equipable_params
      params.require(:equipable).permit(:group, :subgroup, :monster_id)
    end
end
