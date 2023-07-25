class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :check_admin_role, only: [:new, :create, :edit, :update, :destroy]

  # GET /companies or /companies.json
  def index
    @companies = Company.joins(:branches).where(branches: { id: current_user.branch_id })
  end

  # GET /companies/1 or /companies/1.json
  def show
    @company = Company.find(params[:id])

    # Allow showing the branch if it's associated with the current user's branch_id
    # OR if the current user is an admin and the branch is associated with the user's company_id.
    if (@company.id == current_user.branch.company.id) || (current_user.role == "admin" && @company.id == current_user..branch.company.id)
      render :show
    else
      redirect_to root_path, alert: "You do not have permission to access this page."
    end
  end

  # GET /companies/new
  def new
    @company = Company.new
    initialize_company_opening_hours
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        create_default_branch_and_update_user_branch
        format.html { redirect_to company_url(@company), notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        update_user_branch
        format.html { redirect_to company_url(@company), notice: "Company was successfully updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, notice: "Company was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def join
    # Code to display a form for the user to enter a company code
    @companies = Company.all
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_params
        params.require(:company).permit(:name, :company_iden, company_opening_hours_attributes: %i[id day_of_week open_time close_time])
    end

    def initialize_company_opening_hours
        CompanyOpeningHour.day_of_weeks.each do |day_of_week, _index|
            @company.company_opening_hours.build(day_of_week: day_of_week)
        end
    end

    def create_default_branch_and_update_user_branch
        branch = @company.branches.create(name: "New Branch")
        current_user.update(branch_id: branch.id) if current_user
     end

    def update_user_branch
        current_user.update(branch_id: params[:company][:branch_id]) if params[:company][:branch_id] && current_user
    end

    def check_admin_role
        unless current_user.role == "admin"
          redirect_to root_path, alert: "You do not have permission to access this page."
        end
    end
end
