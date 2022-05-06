class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  include Shared
  before_action :set_goal, only: %i[ show edit update destroy ]
  before_action :set_owned
  before_action :set_last_claimed
  before_action :daily_yield?
  before_action :akc_price?
  before_action :split_daily_yield?
  # GET /goals or /goals.json
  def index
    @goals = @user.goals
  end

  # GET /goals/1 or /goals/1.json
  def show
    id = @user.goals.find(params[:id])
    @set_goal = id.goal
    @akc_price = akc_price?
    @unclaimed_coins = id.unclaimed_coins
    @num_days = (Time.now.to_date - @user.goals.last.started_on.to_date).to_i
    @errors = Set.new
    @buy_tribes = buy_tribes(@unclaimed_coins, @set_goal)
    @lab_and_higher = lab_and_higher(@unclaimed_coins, @set_goal)
    @no_tribes = no_tribes(@unclaimed_coins, @set_goal)
    @only_mini_starship = only_mini_starship(@unclaimed_coins, @set_goal)
    @only_mini_lab = only_mini_lab(@unclaimed_coins, @set_goal)

    if @errors.present?
      string = ''
      @errors.each do |k|
        string += "#{k}"
      end
      redirect_to user_goals_path(@user), alert: string
    end
    # @only_mini_lab = nil
    # @buy_tribes = nil
    # @only_mini_starship = nil
    # @no_tribes = nil

  end

  # GET /goals/new
  def new
    @goal = @user.goals.build
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals or /goals.json
  def create
    @last_claimed = Claim.last.claimed.strftime("%d/%m/%Y")
    @goal = @user.goals.build(goal_params)

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
      format.html { redirect_to user_goals_path(@user), notice: "Goal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def set_owned
    @owned = get_owned
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = @user.goals.find(params[:id])
    end

    def set_last_claimed
      @last_claimed = @user.claim.last.claimed.strftime("%Y-%m-%d")
    end

    def set_user
      @user = User.find(current_user.id)
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

    def get_prices(total)
      if total >= 2
        {
          lab_price: calculate_discount(LAB_PRICE, total),
          starship_price: calculate_discount(STARSHIP_PRICE, total),
          city_price: calculate_discount(CITY_PRICE, total),
          arena_price: calculate_discount(ARENA_PRICE, total),
          mini_lab_price: calculate_discount(MINI_LAB_PRICE, total),
          min_star_ship_price: calculate_discount(MINI_STAR_SHIP_PRICE, total)
        }
      else
        {
          lab_price: 100,
          starship_price: 200,
          city_price: 400,
          arena_price: 800,
          mini_lab_price: 10,
          min_star_ship_price: 50
        }
      end

    end

    def no_tribes(unclaimed_coins, goal)
      sum = unclaimed_coins
      daily_yield = get_sum[0]
      return @errors << "Please add Tribe Items before continuing" if daily_yield === 0
      no_tribes_arr = []
      index = 1
      while goal > sum
        sum += daily_yield
        no_tribes_arr << {
          days: index,
          on: Time.now + index.days,
          bought: 0,
          item: nil,
          sum: sum,
          daily_yield: calculate_bonus_goal(daily_yield, index)
        }
        # raise "goal: #{no_tribes_arr}"
        # puts "no_tribes_arr: #{no_tribes_arr}"
        index += 1
      end
      [index, daily_yield, sum, no_tribes_arr]
    end

    def only_mini_starship(unclaimed_coins, goal)
      sum = unclaimed_coins
      daily_yield = get_sum[0]
      total_mini_starships = 0
      return @errors << "Please add Tribe Items before continuing" if daily_yield === 0
      only_mini_starship_arr = []
      total = 0
      days = 0
      max_days = 1
      index = 1
      while goal > sum

        # days += 1
        sum += daily_yield
        # only_mini_starship_arr << {
        #   days: index,
        #   on: nil,
        #   bought: nil,
        #   item: nil,
        #   sum: sum,
        #   daily_yield: daily_yield
        # }
        # if days < max_days
        #   next
        # end
        # if days === max_days
        #   days = 0
        # end

        # puts "days: #{days}"
        prices = get_prices(index)

        count = 0
        # puts "total: #{total}. min_star_ship_price: #{prices[:min_star_ship_price]}"
        # return [index, daily_yield, sum] if (goal < sum) || (index >= days)
        if goal < sum
          only_mini_starship_arr << {
            days: index,
            on: Time.now + index.days,
            bought: count,
            item: 'Mini Starship',
            sum: sum,
            daily_yield: daily_yield
          }
          return [index, daily_yield, sum, only_mini_starship_arr]
        end
        # raise "#{sum } > #{prices[:min_star_ship_price]}"
        while sum > prices[:min_star_ship_price]
          sum -= prices[:min_star_ship_price]
          daily_yield += calculate_bonus_goal(1, index)
          count += 1
          # puts "#{index} Bought mini starship on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
        end
        index += 1
        next if count === 0
        total_mini_starships += count
        total += count
        only_mini_starship_arr << {
          days: index,
          on: Time.now + index.days,
          bought: count,
          item: 'Mini Starship',
          sum: sum,
          daily_yield: daily_yield
        }
        # puts "Total: #{total_mini_starships}. Bought #{count} mini starships on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
      end
      [index, daily_yield, sum, only_mini_starship_arr]
    end

    def only_mini_lab(unclaimed_coins, goal)
      sum = unclaimed_coins
      daily_yield = get_sum[0]
      total_mini_lab = 0
      return @errors << "Please add Tribe Items before continuing" if daily_yield === 0
      only_mini_lab_arr = []
      total = 0
      days = 0
      max_days = 14
      index = 1
      while goal > sum
        sum += daily_yield
        # days += 1
        # if days < max_days
        #   next
        # end
        # if days === max_days
        #   days = 0
        # end

        # puts "days: #{days}"
        prices = get_prices(index)

        count = 0
        # puts "total: #{total}. min_star_lab_price: #{prices[:min_star_ship_price]}"
        # return [index, daily_yield, sum] if (goal < sum) || (index >= days)
        if goal < sum
          only_mini_lab_arr << {
            days: index,
            on: Time.now + index.days,
            bought: count,
            item: 'Mini Lab',
            sum: sum,
            daily_yield: daily_yield
          }
          return [index, daily_yield, sum, only_mini_lab_arr]
        end
        while sum > prices[:mini_lab_price]
          sum -= prices[:mini_lab_price]
          daily_yield += calculate_bonus_goal(0.15, index)
          count += 1
          # puts "#{index} Bought mini starship on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
        end
        next if count === 0
        total_mini_lab += count
        total += count
        only_mini_lab_arr << {
          days: index,
          on: Time.now + index.days,
          bought: count,
          item: 'Lab',
          sum: sum,
          daily_yield: daily_yield
        }
        index += 1
        # puts "Total: #{total_mini_lab}. Bought #{count} mini lab on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
      end
      [index, daily_yield, sum, only_mini_lab_arr]

    end

    def buy_tribes(unclaimed_coins, goal)
      buy_tribes_arr = []
      sum = unclaimed_coins
      mini_starship = false
      lab = false
      starship = false
      city = false
      arena = false
      daily_yield = get_sum[0]
      max_days = 14
      return @errors << "Please add Tribe Items before continuing" if daily_yield === 0
      days = 0
      total = 0
      index = 1
      while goal > sum
        prices = get_prices(index)
        sum += daily_yield
        # days += 1
        # if days < max_days
        #   next
        # end
        # if days === max_days
        #   days = 0
        # end
        if (sum > prices[:min_star_ship_price]) && (mini_starship === false)
          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'Mini Starship',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          daily_yield += calculate_bonus_goal(1, index)
          sum -= prices[:min_star_ship_price]
          mini_starship = true
          total += 1
          buy_tribes_arr << {
            days: index,
            on: Time.now + index.days,
            bought: 1,
            item: 'Mini Starship',
            sum: sum,
            daily_yield: daily_yield
          }
          # puts "#{index} Bought mini starship on #{Time.now + index.days}"

        end
        if (sum > prices[:lab_price]) && (lab === false)
          # puts "total: #{total}. lab_price: #{prices[:lab_price]}"
          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'Lab',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          lab = true
          sum -= prices[:lab_price]
          or_dy = 2.5
          calculated_bonus = calculate_bonus_goal(2.5, index)
          puts "daily_yield: #{daily_yield}"
          daily_yield += calculated_bonus
          after_dy = daily_yield
          total += 1
          buy_tribes_arr << {
            days: index,
            on: Time.now + index.days,
            bought: 1,
            item: 'Lab',
            sum: sum,
            daily_yield: daily_yield
          }
          puts "#{index} Bought lab on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          next
        end
        if (sum > prices[:starship_price]) && (starship === false)
          # puts "total: #{total}. starship_price: #{prices[:starship_price]}"
          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'Starship',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          daily_yield += calculate_bonus_goal(5.2, index)
          sum -= prices[:starship_price]
          starship = true
          total += 1
          buy_tribes_arr << {
            days: index,
            on: Time.now + index.days,
            bought: 1,
            item: 'Starship',
            sum: sum,
            daily_yield: daily_yield
          }
          puts "#{index} Bought starship on #{Time.now + index.days}"
        end
        if (sum > prices[:city_price]) && (city === false)
          # puts "total: #{total}. city_price: #{prices[:city_price]}"
          daily_yield += calculate_bonus_goal(11, index)
          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'City',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          sum -= prices[:city_price]
          city = true
          total += 1

          puts "#{index} Bought city on #{Time.now + index.days}"
        end
        if sum > prices[:arena_price]
          # puts "total: #{total}. arena_price: #{prices[:arena_price]}. sum: #{sum}"
          arena = true

          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'Arena',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          count = 0
          total_arena = 0
          while sum > prices[:arena_price]
            sum -= prices[:arena_price]
            daily_yield += calculate_bonus_goal(24, index)
            count += 1
            # puts "#{index} Bought mini starship on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          end
          next if count === 0
          total_arena += count
          total += count
          buy_tribes_arr << {
            days: index,
            on: Time.now + index.days,
            bought: count,
            item: 'Arena',
            sum: sum,
            daily_yield: daily_yield
          }
          puts "#{index} Total Arena: #{total_arena}. Bought arena on #{Time.now + index.days}"
          # puts "buy_tribes_arr: #{buy_tribes_arr}"
        end
        index += 1
      end
      [index, daily_yield, sum, buy_tribes_arr]
    end

    def lab_and_higher(unclaimed_coins, goal)
      buy_tribes_arr = []
      sum = unclaimed_coins
      lab = false
      starship = false
      city = false
      arena = false
      daily_yield = get_sum[0]
      max_days = 14
      return @errors << "Please add Tribe Items before continuing" if daily_yield === 0
      days = 0
      total = 0
      index = 1
      while goal > sum
        prices = get_prices(index)
        sum += daily_yield
        # days += 1
        # if days < max_days
        #   next
        # end
        # if days === max_days
        #   days = 0
        # end
        if (sum > prices[:lab_price]) && (lab === false)
          # puts "total: #{total}. lab_price: #{prices[:lab_price]}"
          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'Lab',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          lab = true
          sum -= prices[:lab_price]
          or_dy = 2.5
          calculated_bonus = calculate_bonus_goal(2.5, index)
          puts "daily_yield: #{daily_yield}"
          daily_yield += calculated_bonus
          after_dy = daily_yield
          total += 1
          buy_tribes_arr << {
            days: index,
            on: Time.now + index.days,
            bought: 1,
            item: 'Lab',
            sum: sum,
            daily_yield: daily_yield
          }
          puts "#{index} Bought lab on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          next
        end
        if (sum > prices[:starship_price]) && (starship === false)
          # puts "total: #{total}. starship_price: #{prices[:starship_price]}"
          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'Starship',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          daily_yield += calculate_bonus_goal(5.2, index)
          sum -= prices[:starship_price]
          starship = true
          total += 1
          buy_tribes_arr << {
            days: index,
            on: Time.now + index.days,
            bought: 1,
            item: 'Starship',
            sum: sum,
            daily_yield: daily_yield
          }
          puts "#{index} Bought starship on #{Time.now + index.days}"
        end
        if (sum > prices[:city_price]) && (city === false)
          # puts "total: #{total}. city_price: #{prices[:city_price]}"
          daily_yield += calculate_bonus_goal(11, index)
          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'City',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          sum -= prices[:city_price]
          city = true
          total += 1

          puts "#{index} Bought city on #{Time.now + index.days}"
        end
        if sum > prices[:arena_price]
          # puts "total: #{total}. arena_price: #{prices[:arena_price]}. sum: #{sum}"
          arena = true

          if goal < sum
            buy_tribes_arr << {
              days: index,
              on: Time.now + index.days,
              bought: 1,
              item: 'Arena',
              sum: sum,
              daily_yield: daily_yield
            }
            return [index, daily_yield, sum, buy_tribes_arr]
          end
          count = 0
          total_arena = 0
          while sum > prices[:arena_price]
            sum -= prices[:arena_price]
            daily_yield += calculate_bonus_goal(24, index)
            count += 1
            # puts "#{index} Bought mini starship on #{Time.now + index.days}. Sum: #{sum}. Daily yield: #{daily_yield}"
          end
          next if count === 0
          total_arena += count
          total += count
          buy_tribes_arr << {
            days: index,
            on: Time.now + index.days,
            bought: count,
            item: 'Arena',
            sum: sum,
            daily_yield: daily_yield
          }
          puts "#{index} Total Arena: #{total_arena}. Bought arena on #{Time.now + index.days}"
          # puts "buy_tribes_arr: #{buy_tribes_arr}"
        end
        index += 1
      end
      [index, daily_yield, sum, buy_tribes_arr]
    end

    def calc_days(days) end

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