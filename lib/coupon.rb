require 'mongo_mapper'
class Coupon
  include MongoMapper::Document
  
  key :code,        String,   :unique   => true, :required => true
  key :value,       Integer,  :numeric  => true, :required => true
  key :limit,       Integer,  :numeric  => true, :default => 1
  
end