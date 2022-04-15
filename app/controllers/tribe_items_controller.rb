class TribeItemsController < ApplicationController
  before_action :set_tribe_item, only: %i[ show edit update destroy ]
  before_action :set_owned
  before_action :set_price
  before_action :set_sum_of_daily_yield
  # GET /tribe_items or /tribe_items.json
  def index
    @akc_price = AlphaCoin.first.price
    @last_updated = AlphaCoin.first.last_updated.in_time_zone.strftime("%m/%d/%Y %I:%M %p")
    @tribe_items = TribeItem.all.order(:daily_yield)
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

  def tables
    @item = TribeItem.find(params[:id])
  end

  def total_tribes

  end

  def days_until
    starting_balance = @daily_yield
    @goal = 800
    @days_until_next_tribe = calculate_days(starting_balance, @goal)
    @formatted = Time.now + @days_until_next_tribe.days
  end

  private

    def calculate_days(daily_yield, goal)
      sum = 32.23
      lab = false
      starship = false
      city = false
      arena = false
      daily_yield = 2.93
      1.upto(200) do |index|
        sum += daily_yield
        if sum > 100 && lab === false
          sum -= 100
          lab = true
          daily_yield += 2.5
          puts "#{index} Bought lab on #{Time.now + index.days}"
        end
        if sum > 200 && starship === false
          sum -= 200
          starship = true
          daily_yield += 5.2
          puts "#{index} Bought starship on #{Time.now + index.days}"
        end
        if sum > 400 && city === false
          sum -= 400
          city = true
          daily_yield += 11
          puts "#{index} Bought city on #{Time.now + index.days}"
        end
        if sum > 800 && arena === false
          sum -= 800
          arena = true
          daily_yield += 24
          puts "#{index} Bought arena on #{Time.now + index.days}"
          return index
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_tribe_item
      @tribe_item = TribeItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tribe_item_params
      params.require(:tribe_item).permit(:item, :daily_yield, :price, :owned, :goal)
    end

    def get_sum(owned)
      sum = 0
      puts owned
      owned.each do |o|
        o.owned.times do
          sum += o.daily_yield
        end
      end
      sum
    end

    def set_owned
      @owned = TribeItem.where("owned >= ?", 1)
    end

    def set_price
      @akc_price = AlphaCoin.first.price
    end

    def set_sum_of_daily_yield
      @daily_yield = get_sum(@owned)
    end
end