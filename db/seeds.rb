# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rubygems'
require 'faker'

def yard
{ 
	:street_address => Faker::Address.street_address ,
	:city => Faker::Address.city ,
	:state => Faker::Address.state ,
	:zip => Faker::Address.zip_code	
}
end # location

def port
{ 
	:city => Faker::Address.city ,
	:code => Faker::Name.last_name + rand(999999999).to_s
}
end # port

def get1( duck )
	duck[rand(duck.length)]
end # get1

10.times do 
	@user = User.create( 
		:company => Faker::Name.name ,
		:phone => Faker::PhoneNumber.phone_number ,
		:email => Faker::Internet.email ,
		:password => Faker::Lorem.sentence
	) # user
	@item = @user.items.create( 
		:title => Faker::Name.name ,
		:description => Faker::Company.bs ,
		:quantity => rand(2354235) ,
		:material => Faker::Company.catch_phrase ,
		:material_type => Faker::Company.name ,
		:maw => rand(234345)
	) # item
	( @item_locations  ||= []) << ( Yard.create yard )
	@item.at @item_locations.last
end # 10 users
10.times do
	(@domestic ||= []) << ( Port.create port )
	(@foreign ||= []) << ( Port.create port )
	Ship.new(
		:company => Faker::Company.name ,
		:price => rand(234324) ,
	).from(@domestic.last).to(@foreign.last).save # ship
	Truck.new(
		:company => Faker::Company.name ,
		:price => rand(234324) ,
	).from(get1 @item_locations).to(get1 @domestic).save # ship
	Service.create( 
		:company => Faker::Company.name ,
		:title => Faker::Company.catch_phrase ,
		:price => rand(28458) ,
		:description => Faker::Company.bs
	) # service
end # auxiliaries

rand(7).times do
	@category = Category.create( :name => Faker::Name.last_name )
	rand(7).times do
		@category.spawn( :name => Faker::Name.first_name )
	end # 5? times
end # 15? times
