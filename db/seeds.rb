# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rubygems'
require 'faker'

@categories = ['plastics','metals','precious metals','semiconductors','electronics']
@types = ['HPDE','LPDE','PP','Foam','Heroin','Steel','Gold','Silicon','Coal','Copper']
@countries = [ 'USA','China','Japan','Korea','Mexico','Canada','Cuba']
@titles = ['twine','ropes','binds','purge','regrind','dogshit']

def get( something )
	something[rand(something.count)]
end # get

# Step 1: Create 50 users
50.times do 
	user = User.create!( 
		address: Faker::Address.street_address ,
		city: Faker::Address.city ,
		state: Faker::Address.state ,
		zip: Faker::Address.zip ,
		country: get( @countries ) ,
		company: Faker::Company.name + Faker::Company.suffix ,
		phone: Faker::PhoneNumber.phone_number ,
		email: Faker::Internet.email ,
		password: Faker::Company.bs
	) # user
	
	# Step 2: Create up to 15 items each
	rand(15).times do
		item = user.items.create!(
			:type => [rand(5)] ,
			:quantity => rand(99999) ,
			:title => get( @types ) + " " + get( @titles ) ,
			:description => Faker::Lorem.paragraph( rand(5) ) ,
			:category => get( @categories )
		) # item
		location = Location.create!( 
			address: Faker::Address.street_address ,
			city: Faker::Address.city ,
			state: Faker::Address.state ,
			zip: Faker::Address.zip ,
			country: get( @countries )
		) # location
		item.at location
	end # 15? items
	# Step 3: Create a bunch of bids
	rand(20).times do
		bid = user.bid( { :offer => rand(99999) }, rand( Item.count ) )
		location = Location.create!( 
			address: Faker::Address.street_address ,
			city: Faker::Address.city ,
			state: Faker::Address.state ,
			zip: Faker::Address.zip ,
			country: get( @countries )
		) # location
		bid.at location
	end # 20? bids
end # 100 users
