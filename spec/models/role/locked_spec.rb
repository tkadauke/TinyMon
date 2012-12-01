class TestLockedUser
  def initialize
    extend Role::Locked
  end
end

describe Role::Locked do
  it "should not be able to do anything" do
    TestLockedUser.new.can_do_anything?.should == false
  end
  
  it "should be able to see own profile" do
    user = TestLockedUser.new
    user.can_see_profile?(user).should == true
  end
  
  it "should not be able to see any other profile" do
    user = TestLockedUser.new
    user.can_see_profile?(TestLockedUser.new).should == false
  end
end
