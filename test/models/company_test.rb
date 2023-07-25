require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should not save company without name' do
    company = Company.new
    assert_not company.save, 'Saved the company without a name'
  end

  test 'should not save company without company_iden' do
    company = Company.new(name: 'Test Company')
    assert_not company.save, 'Saved the company without a company_iden'
  end

  test 'should save company with name and company_iden' do
    company = Company.new(name: 'Test Company', company_iden: 'TEST123')
    assert company.save, 'Could not save the company with name and company_iden'
  end

  test 'should destroy associated branches when the company is destroyed' do
    company = Company.new(name: 'Test Company', company_iden: 'TEST123')
    company.save

    branch = company.branches.build(name: 'Branch A', branch_iden: 'BRANCH123')
    branch.save

    assert_difference('Branch.count', -1) do
      company.destroy
    end
  end
end
