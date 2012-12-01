class TestAdminUser
  include Role::Admin
end

describe Role::Admin do
  it "should be able to do anything" do
    TestAdminUser.new.can_do_anything?.should == true
  end
end
