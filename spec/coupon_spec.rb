require 'spec_helper'

describe Coupon do
  describe "#create" do
    it "creates a valid coupon" do
      @coupon = Coupon.new(:code=>"code", :value=>50)
      @coupon.code.should == "code"
      @coupon.value.should == 50
      @coupon.limit.should == 1
    end
  end  
end