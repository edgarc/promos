require 'csv'

class Promotion
  
	attr_accessor :name, :coupon_quantity, :coupon_value, :coupon_use_limit, :coupon_prefix,
  :form_filter_id, :filter_minimum_order_amount, :filter_type, :codes
	
	def initialize(name, coupon_quantity, coupon_value, coupon_use_limit, coupon_prefix="", csv_file=nil)
	  @name = name
	  @coupon_quantity = coupon_quantity
	  @coupon_value = coupon_value
	  @coupon_use_limit = coupon_use_limit
	  @coupon_prefix = coupon_prefix
	  @csv_file = csv_file
	  @codes = []
	  puts self.inspect
	end
  
  def generate_codes
   @csv_file.nil? ? get_codes : get_codes_from_csv(@csv_file)
  end
  
  private
  
  def get_codes_from_csv(csv_file) 
    @codes = CSV.read(csv_file).flatten
    puts @codes.inspect
  end
  
  def get_codes
    @coupon_quantity.times do 
      new_code = @coupon_prefix+random_code
      codes.include?(new_code) ? get_codes : @codes.push(new_code)
    end
    puts @codes.inspect
  end
  
  def random_code
      code = (0...8).map{65.+(rand(25)).chr}.join
      return code
  end
  
end