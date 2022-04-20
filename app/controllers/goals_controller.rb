class GoalsController < ApplicationController
  include Shared
  before_action :set_goal, only: %i[ show edit update destroy ]
  before_action :set_owned
  before_action :daily_yield?
  before_action :akc_price?
  before_action :split_daily_yield?
  # GET /goals or /goals.json
  def index
    @goals = Goal.all
  end

  # GET /goals/1 or /goals/1.json
  def show
    id = Goal.find(params[:id])
    @set_goal = id.goal
    @akc_price = akc_price?
    @num_days = (Time.now.to_date - Goal.first.started_on.to_date).to_i
    @buy_tribes = calculate_days(id.unclaimed_coins, @set_goal, @num_days, false, true, false, false, 0)
    @no_tribes = calculate_days(id.unclaimed_coins, @set_goal, @num_days, true, false, false, false, @buy_tribes[0])
    @only_mini_starship = calculate_days(id.unclaimed_coins, @set_goal, @num_days, false, false, true, false, @buy_tribes[0])
    @only_mini_lab = calculate_days(id.unclaimed_coins, @set_goal, @num_days, false, false, false, true, @buy_tribes[0])
  end

  # GET /goals/new
  def new
    @goal = Goal.new
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals or /goals.json
  def create
    @goal = Goal.new(goal_params)

    respond_to do |format|
      if @goal.save
        format.html { redirect_to goal_url(@goal), notice: "Goal was successfully created." }
        format.json { render :show, status: :created, location: @goal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1 or /goals/1.json
  def update
    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to goal_url(@goal), notice: "Goal was successfully updated." }
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1 or /goals/1.json
  def destroy
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to goals_url, notice: "Goal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def set_owned
    @owned = get_owned
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def goal_params
      params.require(:goal).permit(:unclaimed_coins, :goal, :started_on)
    end

    LAB_PRICE = 100
    STARSHIP_PRICE = 200
    CITY_PRICE = 200
    ARENA_PRICE = 800
    MINI_LAB_PRICE = 10
    MINI_STAR_SHIP_PRICE = 50

    def calculate_days(unclaimed_coins, goal, num_days, no_tribes, buy_tribes, only_mini_starship, only_mini_lab, days)
      raise "Unclaimed coins is empty." if unclaimed_coins.nil?

      sum = unclaimed_coins
      lab = false
      starship = false
      city = false
      arena = false
      daily_yield = get_sum
      total_mini_labs = 0
      total_mini_starships = 0
      total = 0
      # puts "No tribes: #{no_tribes}. Buy_tribes: #{buy_tribes}. Only_mini_starship: #{only_mini_starship}.
      # only_mini_lab: #{only_mini_lab}"
      raise "Daily yield is empty." if daily_yield.nil?
      1.upto(goal) do |index|
        if total >= 2
          lab_price = calculate_discount(LAB_PRICE, total)
          starship_price = calculate_discount(STARSHIP_PRICE, total)
          city_price = calculate_discount(CITY_PRICE, total)
          arena_price = calculate_discount(ARENA_PRICE, total)
          mini_lab_price = calculate_discount(MINI_LAB_PRICE, total)
          min_star_ship_price = calculate_discount(MINI_STAR_SHIP_PRICE, total)
        else
          lab_price = 100
          starship_price = 200
          city_price = 400
          arena_price = 800
          mini_lab_price = 10
          min_star_ship_price = 50
        end
        raise 'Lab price is 0.' if lab_price === 0
        if (!(lab_price === LAB_PRICE || lab_price === 98.0) && true) && (total == 2)
          raise "Lab price discount is incorrect. It should be 100 or 98.0, but got #{lab_price} "
        end
        if (!(arena_price === ARENA_PRICE || arena_price === 736.0) && true) && (total == 10)
          raise "Arena price discount is incorrect. It should be 800 or 736.0, but got #{arena_price} "
        end
        if (!(min_star_ship_price === MINI_STAR_SHIP_PRICE || min_star_ship_price === 40) && true) && (total == 58)
          raise "Mini starship price discount is incorrect. It should be 50 or 40.0, but got #{min_star_ship_price} "
        end

        sum += daily_yield
        puts "index: #{index}. sum: #{sum}"
        # sum += calculate_bonus(daily_yield, index)
        if no_tribes === true
          return [index, calculate_bonus(daily_yield, index), sum] if goal < sum || (index >= days)
        end
        next if no_tribes === true
        if (sum > mini_lab_price) && (only_mini_lab === true)
          # puts "total: #{total}. mini_lab_price: #{mini_lab_price}"
          return [index, calculate_bonus(daily_yield, index), sum] if (goal < sum) || (index >= days)
          count = 0
          while sum >= mini_lab_price
            sum -= mini_lab_price
            daily_yield += calculate_bonus(0.15, index)
            count += 1
            # puts "#{index} Bought mini lab on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          end
          total_mini_labs += count
          total += count
          # puts "Total: #{total_mini_labs}. Bought #{count} only mini lab on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          next
        end
        if (sum > min_star_ship_price) && (only_mini_starship === true)
          puts "total: #{total}. min_star_ship_price: #{min_star_ship_price}"
          return [index, daily_yield, sum] if (goal < sum) || (index >= days)
          count = 0
          while sum > min_star_ship_price
            sum -= min_star_ship_price
            daily_yield += calculate_bonus(1, index)
            count += 1
            # puts "#{index} Bought mini starship on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          end
          total_mini_starships += count
          total += count
          puts "Total: #{total_mini_starships}. Bought #{count} mini starships on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          next
        end
        if (sum > lab_price) && lab === false
          puts "total: #{total}. lab_price: #{lab_price}"
          return [index, daily_yield, sum] if goal < sum
          count = 0
          lab = true
          sum -= lab_price
          or_dy = 2.5
          calculated_bonus = calculate_bonus(2.5, index)
          puts "daily_yield: #{daily_yield}"
          daily_yield += calculated_bonus
          after_dy = daily_yield
          total += 1
          puts "#{index} Bought lab on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          next
        end
        if (sum > starship_price) && starship === false
          puts "total: #{total}. starship_price: #{starship_price}"
          return index if goal < sum
          daily_yield += calculate_bonus(5.2, index)
          sum -= starship_price
          starship = true
          total += 1
          puts "#{index} Bought starship on #{Time.now + index.days}"
        end
        if (sum > city_price) && city === false
          puts "total: #{total}. city_price: #{city_price}"
          daily_yield += calculate_bonus(11, index)
          return [index, daily_yield, sum] if goal < sum
          sum -= city_price
          city = true
          total += 1
          puts "#{index} Bought city on #{Time.now + index.days}"
        end
        # puts "sum: #{sum.round(2)}. index: #{index}. Daily yield: #{daily_yield}"
        if (sum > arena_price) && arena === false
          puts "total: #{total}. arena_price: #{arena_price}"
          daily_yield += calculate_bonus(24, index)
          return [index, daily_yield, sum - 800] if goal < sum
          # arena = true
          sum -= arena_price
          total += 1
          puts "#{index} Bought arena on #{Time.now + index.days}"
        end
        # puts "total: #{total}"
        return [index, daily_yield, sum] if goal < sum
      end
    end

    def calculate_discount(tribe, total)
      tribe - (tribe * get_discount(total))
    end

    def get_discount(total)
      case total
        when 0..1
          0
        when 2..4
          0.02
        when 5..9
          0.04
        when 10..14
          0.08
        when 15..19
          0.12
        when 20..49
          0.12
        else
          0.20
      end
    end

    def daily_yield?
      @daily_yield = get_sum
    end

    def split_daily_yield?
      @split_daily_yield = get_split_daily_yield
    end

    def akc_price?
      @akc_price = get_akc_price
    end
end