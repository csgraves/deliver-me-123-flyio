class BranchesController < ApplicationController
  before_action :set_branch, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :check_admin_role, only: [:create, :edit, :update, :destroy]

  # GET /branches or /branches.json
  def index
    @branches = current_user.company.branches
  end

  # GET /branches/1 or /branches/1.json
  def show
    @branch = Branch.find(params[:id])

    # Allow showing the branch if it's associated with the current user's branch_id
    # OR if the current user is an admin and the branch is associated with the user's company_id.
    if (@branch.id == current_user.branch_id) || (current_user.role == "admin" && @branch.company_id == current_user.company.id)
      render :show
    else
      redirect_to root_path, alert: "You do not have permission."
    end
  end

  # GET /branches/new
  def new
    @branch = Branch.new
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches or /branches.json
  def create
    
    @branch = Branch.new(branch_params)
    #company = Company.find_by(company_iden: params[:branch][:company_iden])
    #@branch.company = company

    #company = Company.find_by(params[:company_id])
    company = current_user.company
    @branch.company = company
    @branch.company_iden = company.company_iden

    respond_to do |format|
      if @branch.save
        create_schedule_for_branch
        current_user.update(branch_id: @branch.id) if current_user.branch_id.nil?
        format.html { redirect_to branch_url(@branch), notice: "Branch was successfully created." }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1 or /branches/1.json
  def update
    respond_to do |format|
      if @branch.update(branch_params)
        company = Company.find_by(company_iden: params[:company_iden])
        @branch.company_id = company.id if company
        format.html { redirect_to branch_url(@branch), notice: "Branch was successfully updated." }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1 or /branches/1.json
  def destroy
    @branch.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, notice: "Branch and associated users were successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def join_company
    @company = Company.find(params[:company_id])
    @branches = @company.branches
    render "select_branch"
  end

  def select_branch
      branch = Branch.find(params[:branch_id])
      current_user.update(role: "driver", branch_id: branch.id)
      redirect_to user_dashboard_path, notice: "Branch selected successfully."
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def branch_params
      #params.require(:branch).permit(:name, :branch_iden, :company_iden)
      params.require(:branch).permit(:name, :branch_iden)
    end

    def create_schedule_for_branch
        @branch.create_schedule(branch_id: @branch.id, branch_only: true) # Create a new schedule associated with the branch
    end   

    def check_admin_role
        unless (current_user.role == "admin" && @branch.company.id == current_user.branch.company.id)
          redirect_to root_path, alert: "You do not have permission to access this page."
        end
    end
end
