require 'spec_helper'

describe Promotion do
  
  before(:each) do
    @promo = Promotion.new("test_promotion", 10, 50, 1, "test")
  end
  
  describe "#create" do
    it "creates a valid promotion" do 
      @promo.name.should == "test_promotion"
      @promo.coupon_quantity.should == 10
      @promo.coupon_value.should == 50
      @promo.coupon_use_limit.should == 1
      @promo.codes.should
    end
    
    it "reads codes from a csv file" do
      @promo = Promotion.new("test_promotion", 10, 50, 1, "", fixture("codes.csv"))
      @promo.generate_codes
      @promo.codes.length.should == 3
      @promo.codes.should == ["code1", "code2", "code3"]
    end
    
    it "generates unique promotion codes" do
      @promo.generate_codes
      @promo.codes.length.should == 10  
      @promo.codes.first.length.should == 8 + "test".length
    end
    
    it "generates unique promotion codes with a prefix" do
      @promo.generate_codes 
      @promo.codes.length.should == 10  
      @promo.codes.first.length.should == 8 + "test".length
    end
    
    it "generates a random code" do
      code = @promo.send(:random_code)
      code.should_not be nil
      code.length.should == 8
    end
    
  end  
end