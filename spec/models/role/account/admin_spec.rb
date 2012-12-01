class TestAdminAccount
  include Role::Account::Admin
end

describe Role::Account::Admin do
  it "should be able to do anything" do
    TestAdminAccount.new.can_do_anything?.should == true
  end
end
