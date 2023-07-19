class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /schedules or /schedules.json
  def index
    if current_user.role == 'driver'
      redirect_to schedule_path(current_user.schedule)
    elsif current_user.role == 'admin'
      @schedules = Schedule.where(user_id: current_user.branch.company.users.pluck(:id))
                      .or(Schedule.where(branch_id: current_user.branch.company.branches.pluck(:id)))

      @branch_schedules = Schedule.where(branch_id: current_user.branch.company.branches.pluck(:id))
      @user_schedules = Schedule.where(user_id: current_user.branch.company.users.pluck(:id))
    end
    
  end

  # GET /schedules/1 or /schedules/1.json
  def show
      @schedule = Schedule.find(params[:id])
        @deliveries = @schedule.deliveries

        respond_to do |format|
            format.html # Render the HTML view as usual
            format.json { render json: @deliveries } # Include deliveries in the JSON response
        end
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules or /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to schedule_url(@schedule), notice: "Schedule was successfully created." }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1 or /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to schedule_url(@schedule), notice: "Schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1 or /schedules/1.json
  def destroy
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to schedules_url, notice: "Schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def calendar_schedule
      # Retrieve schedules with branches for the current user's company
      @branch_schedules = Schedule.where(branch_only: true, branch_id: current_user.branch.company.schedules.pluck(:id))
                                  .map { |schedule| [schedule.id, schedule.branch.name] }

      # Retrieve schedules with users for the current user's company
      @user_schedules = Schedule.where(user_only: true, user_id: current_user.branch.company.users.pluck(:id))
                                .map { |schedule| [schedule.id, schedule.branch.name] }

      # Handle form submission and perform additional actions if needed
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      if params[:id] != "calendar_schedule"
        @schedule = Schedule.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def schedule_params
      params.require(:schedule).permit(:start_time, :end_time, :branch_id, :user_id, :user_only, :branch_only)
    end
end
