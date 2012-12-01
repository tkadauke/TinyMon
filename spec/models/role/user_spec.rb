class TestUser
  def initialize
    extend Role::User
  end
end

describe Role::User do
  describe "Account with user role" do
    before do
      Account.current = TestUserAccount.new
    end
  
    it "should be able to edit account" do
      TestUser.new.can_edit_account?.should == true
    end

    it "should be able to add user to account" do
      TestUser.new.can_add_user_to_account?.should == true
    end

    it "should be able to create health checks" do
      TestUser.new.can_create_health_checks?.should == true
    end

    it "should be able to edit health checks" do
      TestUser.new.can_edit_health_checks?.should == true
    end

    it "should be able to delete health checks" do
      TestUser.new.can_delete_health_checks?.should == true
    end

    it "should be able to run health checks" do
      TestUser.new.can_run_health_checks?.should == true
    end

    it "should be able to create sites" do
      TestUser.new.can_create_sites?.should == true
    end

    it "should be able to edit sites" do
      TestUser.new.can_edit_sites?.should == true
    end

    it "should be able to delete sites" do
      TestUser.new.can_delete_sites?.should == true
    end

    it "should be able to create comments" do
      TestUser.new.can_create_comments?.should == true
    end

    it "should be able to create health check templates" do
      TestUser.new.can_create_health_check_templates?.should == true
    end

    it "should be able to edit health check template" do
      TestUser.new.can_edit_health_check_template?.should == true
    end

    it "should be able to create deployments" do
      TestUser.new.can_create_deployments?.should == true
    end
  
    it "should not be able to remove self from account" do
      user = TestUser.new
      user.can_remove_user_from_account?(user).should == false
    end
  
    it "should be able to remove user from account" do
      user = TestUser.new
      user.can_remove_user_from_account?(TestUser.new).should == true
    end
  
    it "should not be able to assign role for self and account" do
      user = TestUser.new
      user.can_assign_role_for_user_and_account?(user).should == false
    end
  
    it "should be able to assign role for user and account" do
      user = TestUser.new
      user.can_assign_role_for_user_and_account?(TestUser.new).should == true
    end
  end
  
  describe "Account with observer role" do
    before do
      Account.current = TestObserverAccount.new
    end
  
    it "should not be able to edit account" do
      TestUser.new.can_edit_account?.should == false
    end

    it "should not be able to add user to account" do
      TestUser.new.can_add_user_to_account?.should == false
    end

    it "should not be able to create health checks" do
      TestUser.new.can_create_health_checks?.should == false
    end

    it "should not be able to edit health checks" do
      TestUser.new.can_edit_health_checks?.should == false
    end

    it "should not be able to delete health checks" do
      TestUser.new.can_delete_health_checks?.should == false
    end

    it "should not be able to run health checks" do
      TestUser.new.can_run_health_checks?.should == false
    end

    it "should not be able to create sites" do
      TestUser.new.can_create_sites?.should == false
    end

    it "should not be able to edit sites" do
      TestUser.new.can_edit_sites?.should == false
    end

    it "should not be able to delete sites" do
      TestUser.new.can_delete_sites?.should == false
    end

    it "should not be able to create comments" do
      TestUser.new.can_create_comments?.should == false
    end

    it "should not be able to create health check templates" do
      TestUser.new.can_create_health_check_templates?.should == false
    end

    it "should not be able to edit health check template" do
      TestUser.new.can_edit_health_check_template?.should == false
    end

    it "should not be able to create deployments" do
      TestUser.new.can_create_deployments?.should == false
    end
  
    it "should not be able to remove self from account" do
      user = TestUser.new
      user.can_remove_user_from_account?(user).should == false
    end
  
    it "should not be able to remove user from account" do
      user = TestUser.new
      user.can_remove_user_from_account?(TestUser.new).should == false
    end
  
    it "should not be able to assign role for self and account" do
      user = TestUser.new
      user.can_assign_role_for_user_and_account?(user).should == false
    end
  
    it "should not be able to assign role for user and account" do
      user = TestUser.new
      user.can_assign_role_for_user_and_account?(TestUser.new).should == false
    end
  end
  
  describe "Account with admin role" do
    before do
      Account.current = TestAdminAccount.new
    end
  
    it "should be able to edit account" do
      TestUser.new.can_edit_account?.should == true
    end

    it "should be able to add user to account" do
      TestUser.new.can_add_user_to_account?.should == true
    end

    it "should be able to create health checks" do
      TestUser.new.can_create_health_checks?.should == true
    end

    it "should be able to edit health checks" do
      TestUser.new.can_edit_health_checks?.should == true
    end

    it "should be able to delete health checks" do
      TestUser.new.can_delete_health_checks?.should == true
    end

    it "should be able to run health checks" do
      TestUser.new.can_run_health_checks?.should == true
    end

    it "should be able to create sites" do
      TestUser.new.can_create_sites?.should == true
    end

    it "should be able to edit sites" do
      TestUser.new.can_edit_sites?.should == true
    end

    it "should be able to delete sites" do
      TestUser.new.can_delete_sites?.should == true
    end

    it "should be able to create comments" do
      TestUser.new.can_create_comments?.should == true
    end

    it "should be able to create health check templates" do
      TestUser.new.can_create_health_check_templates?.should == true
    end

    it "should be able to edit health check template" do
      TestUser.new.can_edit_health_check_template?.should == true
    end

    it "should be able to create deployments" do
      TestUser.new.can_create_deployments?.should == true
    end
  
    it "should not be able to remove self from account" do
      user = TestUser.new
      user.can_remove_user_from_account?(user).should == false
    end
  
    it "should be able to remove user from account" do
      user = TestUser.new
      user.can_remove_user_from_account?(TestUser.new).should == true
    end
  
    it "should not be able to assign role for self and account" do
      user = TestUser.new
      user.can_assign_role_for_user_and_account?(user).should == false
    end
  
    it "should be able to assign role for user and account" do
      user = TestUser.new
      user.can_assign_role_for_user_and_account?(TestUser.new).should == true
    end
  end

  it "should be able to edit own profile" do
    user = TestUser.new
    user.can_edit_profile?(user).should == true
  end
  
  it "should not be able to edit any other profile" do
    user = TestUser.new
    user.can_edit_profile?(TestUser.new).should == false
  end

  it "should be able to edit settings" do
    TestUser.new.can_edit_settings?.should == true
  end

  it "should be able to see account details" do
    TestUser.new.can_see_account_details?.should == true
  end
  
  it "should not be able to do anything else" do
    TestUser.new.can_do_anything?.should == false
  end
end
