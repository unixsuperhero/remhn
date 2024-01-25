class MonsterElementsController < ApplicationController
  before_action :set_monster_element, only: %i[ show edit update destroy ]

  # GET /monster_elements or /monster_elements.json
  def index
    @monster_elements = MonsterElement.all
  end

  # GET /monster_elements/1 or /monster_elements/1.json
  def show
  end

  # GET /monster_elements/new
  def new
    @monster_element = MonsterElement.new
  end

  # GET /monster_elements/1/edit
  def edit
  end

  # POST /monster_elements or /monster_elements.json
  def create
    @monster_element = MonsterElement.new(monster_element_params)

    respond_to do |format|
      if @monster_element.save
        format.html { redirect_to monster_element_url(@monster_element), notice: "Monster element was successfully created." }
        format.json { render :show, status: :created, location: @monster_element }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @monster_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monster_elements/1 or /monster_elements/1.json
  def update
    respond_to do |format|
      if @monster_element.update(monster_element_params)
        format.html { redirect_to monster_element_url(@monster_element), notice: "Monster element was successfully updated." }
        format.json { render :show, status: :ok, location: @monster_element }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @monster_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monster_elements/1 or /monster_elements/1.json
  def destroy
    @monster_element.destroy

    respond_to do |format|
      format.html { redirect_to monster_elements_url, notice: "Monster element was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monster_element
      @monster_element = MonsterElement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def monster_element_params
      params.require(:monster_element).permit(:monster_id, :element_id)
    end
end
