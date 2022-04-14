class TribeItemsController < ApplicationController
  before_action :set_tribe_item, only: %i[ show edit update destroy ]

  # GET /tribe_items or /tribe_items.json
  def index
    @akc_price = AlphaCoin.first.price
    @last_updated = AlphaCoin.first.last_updated.in_time_zone.strftime("%m/%d/%Y %I:%M %p")
    @daily_yield = TribeItem.where("owned >= ?", 1).sum(:daily_yield)
    @tribe_items = TribeItem.all
  end

  # GET /tribe_items/1 or /tribe_items/1.json
  def show
  end

  # GET /tribe_items/new
  def new
    @tribe_item = TribeItem.new
  end

  # GET /tribe_items/1/edit
  def edit
  end

  # POST /tribe_items or /tribe_items.json
  def create
    @tribe_item = TribeItem.new(tribe_item_params)

    respond_to do |format|
      if @tribe_item.save
        format.html { redirect_to tribe_item_url(@tribe_item), notice: "Tribe item was successfully created." }
        format.json { render :show, status: :created, location: @tribe_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tribe_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tribe_items/1 or /tribe_items/1.json
  def update
    respond_to do |format|
      if @tribe_item.update(tribe_item_params)
        format.html { redirect_to tribe_item_url(@tribe_item), notice: "Tribe item was successfully updated." }
        format.json { render :show, status: :ok, location: @tribe_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tribe_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tribe_items/1 or /tribe_items/1.json
  def destroy
    @tribe_item.destroy

    respond_to do |format|
      format.html { redirect_to tribe_items_url, notice: "Tribe item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tribe_item
      @tribe_item = TribeItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tribe_item_params
      params.require(:tribe_item).permit(:item, :daily_yield, :price, :owned)
    end
end