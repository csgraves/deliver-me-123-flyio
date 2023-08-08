class Branch < ApplicationRecord
  belongs_to :company
  has_many :users, dependent: :destroy
  has_one :schedule, dependent: :destroy
  validates :name, presence: true


  after_create :create_default_schedule

  private
  # Create a new schedule associated with the branch
  def create_default_schedule
    create_schedule(branch_id: id, branch_only: true) 
  end

end
