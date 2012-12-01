class TestObserverAccount
  include Role::Account::Observer
end

describe Role::Account::Observer do
  it "should not be able to do anything" do
    TestObserverAccount.new.can_do_anything?.should == false
  end
end
