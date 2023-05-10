class Schedule < ApplicationRecord
  belongs_to :branch, optional: true
  belongs_to :user, optional: true

  has_many :deliveries

  # validation to ensure that a schedule belongs to either a user or a branch
  validate :user_or_branch_presence

  private

  def user_or_branch_presence
    errors.add(:base, "Schedule must belong to a user or a branch") unless user.present? || branch.present?
  end
end
