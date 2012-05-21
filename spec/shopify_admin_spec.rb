require 'spec_helper'

describe ShopifyAdmin do
  before(:each) do
    @promo = Promotion.new("spec_promotion", 1, 50, 1)
    @env = Environment.new("**.myshopify.com", "email", "pass")
    @admin = ShopifyAdmin.new([@promo], @env)
  end
  
  describe "#create" do
    it "creates a valid admin" do
      @admin.promotions.first.should be_an_instance_of Promotion
      @admin.promotions.first.should == @promo
      @admin.env.should be_an_instance_of Environment
      @admin.env.should == @env
    end
    
    it "goes to login page" do
      response = @admin.login
      response.links.to_s.scan("Logout").count.should be > 0
    end
    
    it "creates a coupon on the admin page" do
      @admin.login
      @promo.generate_codes
      @admin.create_discounts_for @promo
      response = @admin.navigate_to_marketing
      response.parser.xpath('//table//tr').to_s.scan(@promo.codes.first).count.should be > 0
    end
    
    it "creates a coupon & persists it on the database" do
      @admin = ShopifyAdmin.new([@promo], @env, {:host=>"localhost", :port=>27017, :db=>"spec_promotion"})
      @admin.create_coupons
      Coupon.where(:code=>@promo.codes.first).count.should be == 1
    end
    
    it "creates coupons from a csv file"
    
    it "works with more than one promotion"
  end  
  
end