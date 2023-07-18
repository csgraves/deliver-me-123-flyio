class Branch < ApplicationRecord
  belongs_to :company
  has_many :users, dependent: :destroy
  has_one :schedule, dependent: :destroy

  after_create :create_default_schedule

  private

  def create_default_schedule
    create_schedule(branch_id: id, branch_only: true) # Create a new schedule associated with the branch
  end

end
