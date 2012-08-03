require 'faker'

Factory.sequence :company do |n|
	Faker::Company.name
end # company

Factory.sequence :shipping do |n|
	['EXWORKS','FAS','FOB','CNF','CIF'][n%5]
end # shipping

Factory.sequence :password do |n|
	(0..64).map { |x| ("a".."z").map { |y| y }[rand(26)] }.join
end # password

Factory.sequence :phone do |n|
	(0..9).map { (0..9).map { |x| x }[rand(10)] }.join
end # Factory

Factory.sequence :zipcode do |n|
	(1..5).map { rand(9) }.join
end # zipcode

Factory.sequence :state do |n|
	['California','Nevada','Washington','Arizona','Texas','Faggots'][rand(6)]
end # state

Factory.sequence :units do |n|
	["pounds","tons","kilograms","batches"][rand(4)]
end # units

Factory.sequence :email do |n|
  "testdrone#{n}" + (0..5).map{ ('a'..'z').map { |y|y }[rand(26)] }.join + "@test.com"
end

Factory.sequence :name do |n|
  "Alice McTest#{n}"
end

Factory.sequence :random_string do |n|
  (0..55).map { |x| ("a".."z").map { |y| y }[rand(26)] }.join
end

Factory.sequence :city do |n|
	["Springfield","Berkeley","Los Angeles","Palo Alto","Fagville"][rand(5)]
end # city

Factory.sequence :address do |n|
	"#{n} " + ['Spruce','Maple','Cherry','Mariposa','Apple','Faggot'][rand(6)] + ['St','Ave','Pkwy','Ln','Rd','Way'][rand(6)]
end # address

Factory.sequence :country do |n|
	["United States","Brazil","Japan","China","South Korea","Italy","France"][rand(7)]
end # country

Factory.define :bid do |bid|
	bid.offer rand(18348)
	bid.association :item
	bid.association :user
end # bid

Factory.sequence :bid do |n|
	{ :offer => rand(34334) }
end # sequence

Factory.define :item do |item|
	item.title Factory.next( :random_string )
	item.description Factory.next( :random_string )
	item.quantity rand(500)
	item.units Factory.next( :units )
	item.association :user
	item.material Factory.next(:random_string)
	item.category "plastic"
	item.material_type [:hdpe, :ldpe, :pp, :pet][rand(4)].to_s
end # item

Factory.sequence :item do |n|
	{ 
	:title => Factory.next( :random_string ) ,
	:description => Factory.next( :random_string ) ,
	:quantity => rand( 500 ),
	:units => Factory.next( :units ) ,
	:material => Factory.next(:random_string) ,
	:category => "plastic" ,
	:material_type => [:hdpe, :ldpe, :pp, :pet][rand(4)].to_s
	}
end # item

Factory.define :user do |user|
	user.email Factory.next( :email )
	user.phone Factory.next( :phone )
	user.company Factory.next( :name )
	user.password Factory.next( :random_string )
end # user

Factory.sequence :user do |n|
	{ 
	:email => Factory.next( :email ) ,
	:phone => Factory.next( :phone ) ,
	:company => Factory.next( :name ) ,
	:password => Factory.next( :random_string )
	}
end # user

Factory.define :element do |element|
  include ActionDispatch::TestProcess
  element.metadata (0..30).map { |x| ("a".."z").map{ |y| y }[rand(26)] }.join
  element.picture fixture_file_upload(Rails.root + 'spec/pics/pic0.png', 'image/png')
  element.association :item
end # element

Factory.sequence :element do |n|
	include ActionDispatch::TestProcess
	{ 
	:metadata => (0..30).map { |x| ("a".."z").map{ |y| y }[rand(26)] }.join ,
	:picture => fixture_file_upload(Rails.root + 'spec/pics/pic0.png', 'image/png')
	}
end # element

Factory.define :location do |location|
	location.address Factory.next(:address)
	location.city Factory.next(:city)
	location.state Factory.next(:state)
	location.zip Factory.next(:zipcode)
	location.name Factory.next(:random_string)
	location.country Factory.next(:country)
	location.shipping Factory.next(:shipping)
end # location

Factory.sequence :location do |n|
{ 
	:address =>  Factory.next(:address) ,
	:city => Factory.next(:city),
	:state => Factory.next(:state) ,
	:zip => Factory.next(:zipcode),
	:name => Factory.next(:random_string) ,
	:country => Factory.next(:country) ,
	:shipping => Factory.next(:shipping)
}
end # location
