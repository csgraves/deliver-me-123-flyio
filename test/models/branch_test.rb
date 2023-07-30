require "test_helper"

class BranchTest < ActiveSupport::TestCase

    test "should not save branch without name" do
        branch = Branch.new
        assert_not branch.save, "Saved the branch without a name"
    end

    test "should save branch with valid attributes" do
        branch = Branch.new(name: "Test Branch", branch_iden: "test-branch", company_iden: "test-company", company_id: companies(:one).id)
        assert branch.save, "Could not save the branch with valid attributes"
    end

    test "should belong to a company" do
        branch = Branch.new(name: "Test Branch", branch_iden: "test-branch", company_iden: "test-company")
        assert_not branch.save, "Saved the branch without associating it to a company"
    end

    test "should have many users" do
        branch = branches(:one)
        user = users(:one)
        branch.users << user
        assert_includes branch.users, user, "Branch does not have the associated user"
      end

      test "should have one schedule" do
        branch = branches(:one)
        schedule = schedules(:one)
        branch.schedule = schedule
        assert_equal branch.schedule, schedule, "Branch does not have the associated schedule"
      end
      
end
