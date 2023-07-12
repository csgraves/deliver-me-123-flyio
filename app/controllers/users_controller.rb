class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    #@user.branch_id = nil

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /users/fetch_users
  def fetch_users
    pot_origin_leave = params[:pot_origin_leave]
    pot_dest_arrive = params[:pot_dest_arrive]

    # Fetch users based on the conditions mentioned
    users = User.joins(:availabilities)
                .joins(branch: :company)
                .joins(:schedules)
                .where('availabilities.start_time <= ?', pot_origin_leave)
                .where('availabilities.end_time >= ?', pot_dest_arrive)
                .where(branch_id: current_user.branch_id)
                .where.not(id: User.joins(schedules: { deliveries: :schedule })
                              .where('deliveries.origin_leave <= ?', pot_dest_arrive)
                              .where('deliveries.dest_arrive >= ?', pot_origin_leave)
                              .pluck(:id))
                .distinct

    # Print name, email, and schedule_id to console
    users.each do |user|
        puts "Name: #{user.name}, Email: #{user.email}, Schedule ID: #{user.schedules.first.id}"
    end

    render json: users, only: [:name, :email], include: { schedules: { only: :id } }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user

      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password_digest, :role, :branch_id)
    end
end
