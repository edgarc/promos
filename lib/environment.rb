class Environment
  
  LOGIN_PATH = "/auth/login"
  MARKETING_PATH = "/marketing"
  DISCOUNTS_PATH = "/discounts"
  
	attr_accessor :url, :user, :password
	
	def initialize(url, user, password)
	  @url = "https://" + url + "/admin"
	  @user = user
	  @password = password
	end    
	
	def login_url
	  @url + LOGIN_PATH
	end  
	
	def marketing_url
	  @url + MARKETING_PATH
	end
	
	def discounts_action_url
	  @url + DISCOUNTS_PATH
	end
end