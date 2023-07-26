class DeliveriesController < ApplicationController
  before_action :set_delivery, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :check_admin_role, only: [:show, :edit, :update, :destroy]

  # GET /deliveries or /deliveries.json
  def index
    @deliveries = current_user.schedule.deliveries
  end

  # GET /deliveries/1 or /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    unless (current_user.role == "admin")
        redirect_to root_path, alert: "You do not have permission."
        return
    end
    @delivery = Delivery.new
  end

  # GET /deliveries/1/edit
  def edit
  end

  # POST /deliveries or /deliveries.json
  def create
    @delivery = Delivery.new(delivery_params)
    #@delivery.dest_address = params[:delivery][:dest_address]
    #@delivery.origin_address = params[:delivery][:origin_address]

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to delivery_url(@delivery), notice: "Delivery was successfully created." }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliveries/1 or /deliveries/1.json
  def update
    respond_to do |format|
      if @delivery.update(delivery_params)
        format.html { redirect_to delivery_url(@delivery), notice: "Delivery was successfully updated." }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1 or /deliveries/1.json
  def destroy
    @delivery.destroy

    respond_to do |format|
      format.html { redirect_to deliveries_url, notice: "Delivery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def delivery_params
      params.require(:delivery).permit(
        :origin_leave, 
        :schedule_id, 
        :origin_address,
        :origin_lat,
        :origin_lon,
        :dest_address,
        :dest_lat,
        :dest_lon,
        :dest_arrive,
        :dest_leave)
    end

    def check_admin_role
        unless ((current_user.role == "admin" && @delivery.schedule.user.branch.company.id == current_user.branch.company.id) || current_user == @delivery.schedule.user)
          redirect_to root_path, alert: "You do not have permission."
        end
    end
end
