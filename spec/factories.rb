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

Factory.define :item do |item|
	item.title Factory.next( :random_string )
	item.description Factory.next( :random_string )
	item.quantity rand(500)
	item.units Factory.next( :units )
	item.association :user
end # item

Factory.sequence :item do |n|
	{ 
	:title => Factory.next( :random_string ) ,
	:description => Factory.next( :random_string ) ,
	:quantity => rand( 500 ),
	:units => Factory.next( :units ) ,
	}
end # item

Factory.define :user do |user|
	user.address Factory.next( :address )
	user.city Factory.next( :city )
	user.state Factory.next( :state )
	user.country Factory.next( :country )
	user.zip Factory.next( :zipcode )
	user.email Factory.next( :email )
	user.company Factory.next( :name )
	user.password Factory.next( :random_string )
end # user

Factory.sequence :user do |n|
	{ 
	:address => Factory.next( :address ) ,
	:city => Factory.next( :city ) ,
	:state => Factory.next( :state ) ,
	:country => Factory.next( :country ) ,
	:zip => Factory.next( :zipcode ) ,
	:email => Factory.next( :email ) ,
	:company => Factory.next( :name ) ,
	:password => Factory.next( :random_string )
	}
end # user




