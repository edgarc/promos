require 'mechanize'

class ShopifyAdmin
  
  attr_accessor :promotions, :env
  
  def initialize(promotions, environment, persist={}, proxy={})
    @promotions = promotions
    @env = environment
    @persist = persist
    unless @persist.empty?
      MongoMapper.connection = Mongo::Connection.new(@persist[:host], @persist[:port], :pool_size => 5, :timeout => 5)
    end
    @agent = Mechanize.new
    @agent.set_proxy proxy[:host], proxy[:port] unless proxy.empty?
  end  
  
  def create_coupons
    login
    @promotions.each do |promotion|
      MongoMapper.database = 'shopify_discounts_' + promotion.name
      promotion.generate_codes
      create_discounts_for promotion
    end  
  end
  
  def login
    page = @agent.get(@env.login_url)
    form = page.forms.first
    form.login = @env.user
    form.password = @env.password
    @agent.submit(page.forms.first)
  end
  
  def navigate_to_marketing
    @agent.get(@env.marketing_url)
  end
  
  def create_discounts_for(promotion)
    @agent.get(@env.marketing_url) do |page|
      promotion.codes.each do |code|
        new_coupon = Coupon.new(:code=>code, :value=>promotion.coupon_value, :limit=>promotion.coupon_use_limit)
        puts new_coupon.inspect
        begin
          page.form_with(:action => @env.discounts_action_url) do |f|
            #hack to assign the same value to both text inputs named discount_value since makes the operation to fail
            f.fields_with(:id => "discount_value").each do |field|
              field.value = new_coupon.value
            end
            f.send("discount[code]=", new_coupon.code )
            f.send("discount[usage_limit]=", new_coupon.limit)
            f.send("discount[value]=", new_coupon.value)
          end.click_button
          puts new_coupon.save unless @persist.empty? 
          
        rescue Mechanize::ResponseCodeError
            puts "ResponseCodeError - Code: #{$!}"
        end
      end
    end
    
  end
  
  def find_coupon(code)
    login
    @agent.get(@env.marketing_url) do |page|
      search_coupon(code, page)
    end
  end
  
  def search_coupon(code, page)
    content = page.parser.xpath('//table').to_html
    find_code = content.scan(code)
    if find_code.empty?
      puts page.uri.to_s + " - not found"
      next_page = @agent.click(page.link_with(:text => /Next/))
      search_coupon(code, next_page)
    else
      puts page.uri.to_s
      puts find_code.inspect
    end
  end
  
  #TODO validate filters
  def form_filters
    f.fields_with(:name => "discount[applies_to_id]").each do |field|
      field.value = promotion.form_filter_id
    end
    f.fields_with(:name => "discount[applies_to_type]").each do |field|
      field.value = promotion.filter_type
    end
    f.fields_with(:name => "discount[minimum_order_amount]").each do |field|
      field.value = promotion.filter_minimum_order_amount
    end
    f.send("discount[applies_to_type]=", promotion.filter_type)
    f.send("discount[applies_to_id]=", promotion.form_filter_id)
    f.send("discount[minimum_order_amount]=", promotion.filter_minimum_order_amount)
  end
  
end