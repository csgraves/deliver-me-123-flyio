class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_lesson, only: [:new]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @account = Account.new
    @user = User.new 
    @client = Client.new
    @booking = Booking.new
    @lesson_payment = LessonPayment.new
    @schedules = Schedule.where('start >= ? and start <=  ?', Date.today + 1.day, Date.today + 2.weeks).where(title: 'Available').order('start ASC').all
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    #create_client_account  
    @user = User.new(user_params)
    #@user.account_id = @account.id

    respond_to do |format|
      if @user.save

        #create_client_profile
        #create_client_booking
        #create_client_lesson_payment
        #auto_login(@user)
        #UserMailer.new_signup_booking_admin(@user, @booking).deliver_later
        #UserMailer.new_signup_booking_client(@user, @booking).deliver_later

        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity } #old
        #format.html { redirect_back fallback_location: root_path, alert: 'An error occurred while sending this request.' } #new
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_lesson
        #@lesson = Lesson.find(params[:lesson_id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:user_id, :account_id, :first_name, :last_name, :time_zone) #old
      #params.require(:user).permit(:email, :password, :time_zone) #new
    end

end
