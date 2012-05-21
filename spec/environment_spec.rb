require 'spec_helper'

describe Environment do
  
  describe "#create" do
    it "creates a valid environment" do
      @env = Environment.new("test.com", "myuser", "mypass")
      @env.user.should == "myuser"
      @env.password.should == "mypass"
      @env.url.should == "https://test.com/admin"
      @env.login_url.should == "https://test.com/admin/auth/login"
      @env.marketing_url.should == "https://test.com/admin/marketing"
      @env.discounts_action_url.should == "https://test.com/admin/discounts"
    end
  end  
  
end