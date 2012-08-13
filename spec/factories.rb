require 'faker'

alias :Faggotory :Factory
def Factory( label, options = {} )
	case label
		when :location
			return Location.create Factory.next(:location)
		when :user
			u = User.new Factory.next(:user)
			if options[:admin]
				u.admin = true
			end
			u.save!
			return u
		else
			return Faggotory(label, options)
	end # case label
end # Factory


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

Factory.sequence :random_hash do |n|
	output = {}
	(1 + rand(24)).times do |k|
		output["field#{k}".to_sym] = "entry_number#{k}"
	end # times k
	output
end # random_hash

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
	bid.shipping Factory.next(:shipping)
	bid.association :item
	bid.association :user
end # bid

Factory.sequence :bid do |n|
{ 
	:offer => rand(34334) ,
	:shipping => Factory.next(:shipping)
}
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
	item.maw rand(23434)
end # item

Factory.sequence :item do |n|
	{ 
	:title => Factory.next( :random_string ) ,
	:description => Factory.next( :random_string ) ,
	:quantity => rand( 500 ),
	:units => Factory.next( :units ) ,
	:material => Factory.next(:random_string) ,
	:category => "plastic" ,
	:material_type => [:hdpe, :ldpe, :pp, :pet][rand(4)].to_s ,
	:maw => rand(234324)
	}
end # item

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

# Here is a workaround to resolve the issue that the Factory.define provided
# by factorygirl refuses to generate unique entries on entries which should
# be unique. God, I hope this works lol

Factory.define :location do |location|
	location.address Factory.next(:address)
	location.city Factory.next(:city)
	location.state Factory.next(:state)
	location.zip Factory.next(:zipcode)
	location.name (Faker::Name.name + rand(13893749237492).to_s)
	location.country Factory.next(:country)
	location.shipping Factory.next(:shipping)
end # location

Factory.sequence :location do |n|
{ 
	:address =>  Factory.next(:address) ,
	:city => Factory.next(:city),
	:state => Factory.next(:state) ,
	:zip => Factory.next(:zipcode),
	:name => Faker::Name.name + rand(13893749237492).to_s,
	:country => Factory.next(:country) ,
	:shipping => Factory.next(:shipping) ,
}
end # location

Factory.define :category do |category|
	category.name Factory.next(:random_string)
end # category

Factory.sequence :category do |n|
{ 
	:name => Factory.next(:random_string)
}
end # category

[:ship, :truck].each do |transport|
	Factory.define transport do |ship|
		ship.company Faker::Company.name
		ship.price rand(99999)
		ship.association :origination
		ship.association :destination
	end # ship
	
	Factory.sequence transport do |n|
	{ 
		:company => Faker::Company.name ,
		:price => rand(99999)
	}
	end # sequence transport
end # each transport

Factory.define :service do |service|
	service.company Faker::Company.name
	service.price rand(9999)
	service.title ['CCIC','Sample Request','Packing Monitoring','Prostitution'][rand(4)]
	service.description Faker::Company.bs
end # service

Factory.sequence :service do |n|
{ 
	:company => Faker::Company.name ,
	:price => rand(999999),
	:title => ['CCIC','Sample Request','Packing Monitoring','Prostitution'][rand(4)] ,
	:description => Faker::Company.bs
}
end # service
