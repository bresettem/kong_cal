class ClaimsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_claim, only: %i[ show edit update destroy ]
  # GET /claims or /claims.json
  def index
    @claims = @user.claim
  end

  # GET /claims/1 or /claims/1.json
  def show
  end

  # GET /claims/new
  def new
    @claim = Claim.new
  end

  # GET /claims/1/edit
  def edit
  end

  # POST /claims or /claims.json
  def create
    @claim = @user.claim.build(claim_params)

    respond_to do |format|
      if @claim.save
        format.html { redirect_to claim_url(@claim), notice: "Claim was successfully created." }
        format.json { render :show, status: :created, location: @claim }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claims/1 or /claims/1.json
  def update
    respond_to do |format|
      if @claim.update(claim_params)
        format.html { redirect_to claim_url(@claim), notice: "Claim was successfully updated." }
        format.json { render :show, status: :ok, location: @claim }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claims/1 or /claims/1.json
  def destroy
    @claim.destroy

    respond_to do |format|
      format.html { redirect_to claims_url, notice: "Claim was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_claim
      @claim = @user.claim.find(params[:id])
    end

    def set_user
      @user = User.find(current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def claim_params
      params.require(:claim).permit(:claimed)
    end
end