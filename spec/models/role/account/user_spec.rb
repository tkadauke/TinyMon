class TestUserAccount
  def initialize
    extend Role::Account::User
  end
end

describe Role::Account::User do
  it "should be able to edit account" do
    TestUserAccount.new.can_edit_account?.should == true
  end

  it "should be able to add user to account" do
    TestUserAccount.new.can_add_user_to_account?.should == true
  end

  it "should be able to create health checks" do
    TestUserAccount.new.can_create_health_checks?.should == true
  end

  it "should be able to edit health checks" do
    TestUserAccount.new.can_edit_health_checks?.should == true
  end

  it "should be able to delete health checks" do
    TestUserAccount.new.can_delete_health_checks?.should == true
  end

  it "should be able to run health checks" do
    TestUserAccount.new.can_run_health_checks?.should == true
  end

  it "should be able to create sites" do
    TestUserAccount.new.can_create_sites?.should == true
  end

  it "should be able to edit sites" do
    TestUserAccount.new.can_edit_sites?.should == true
  end

  it "should be able to delete sites" do
    TestUserAccount.new.can_delete_sites?.should == true
  end

  it "should be able to create comments" do
    TestUserAccount.new.can_create_comments?.should == true
  end

  it "should be able to create health check templates" do
    TestUserAccount.new.can_create_health_check_templates?.should == true
  end

  it "should be able to edit health check template" do
    TestUserAccount.new.can_edit_health_check_template?.should == true
  end

  it "should be able to create deployments" do
    TestUserAccount.new.can_create_deployments?.should == true
  end
end
