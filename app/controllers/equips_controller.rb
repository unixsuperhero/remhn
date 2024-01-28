class EquipsController < ApplicationController
  expose(:equip)

  # GET /equips or /equips.json
  def index
    @equips = Equip.all
  end

  # GET /equips/1 or /equips/1.json
  def show
  end

  # GET /equips/new
  def new
    @equip = Equip.new
  end

  # GET /equips/1/edit
  def edit
  end

  # POST /equips or /equips.json
  def create
    @equip = Equip.new(equip_params)

    respond_to do |format|
      if @equip.save
        format.html { redirect_to equip_url(@equip), notice: "Equip was successfully created." }
        format.json { render :show, status: :created, location: @equip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @equip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equips/1 or /equips/1.json
  def update
    respond_to do |format|
      if @equip.update(equip_params)
        format.html { redirect_to equip_url(@equip), notice: "Equip was successfully updated." }
        format.json { render :show, status: :ok, location: @equip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @equip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equips/1 or /equips/1.json
  def destroy
    @equip.destroy

    respond_to do |format|
      format.html { redirect_to equips_url, notice: "Equip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equip
      @equip = Equip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def equip_params
      params.require(:equip).permit(:name, :set_name, :equip_type, :equip_subtype, :unlock, :starter, :event_only, :atk_scheme, :crit_scheme, :elem_scheme, :monster_id, :element_id)
    end
end
