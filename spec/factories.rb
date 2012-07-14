FactoryGirl.define do
	
	sequence :email do |n|
		"testdrone#{n}@test.com"
	end # email
	
	sequence :name do |n|
		"Alice McTest#{n}"
	end # name
	
	sequence :address do |n|
		"#{n} " + ['Spruce','Maple','Cherry','Mariposa','Apple','Faggot'][rand(6)] + ['St','Ave','Pkwy','Ln','Rd','Way'][rand(6)]
	end # address
	sequence :random_string do |n|
		(0..55).map { |x| ("a".."z").map { |y| y }[rand(26)] }.join
	end # random_string
	
	sequence :item do |n|
		{ 
			:title => FactoryGirl.generate(:random_string) ,
			:description => FactoryGirl.generate(:random_string) ,
			:quantity => rand(500) ,
			:units => ["pounds","tons","kilograms","batches"][rand(4)]
		}
	end # item
	
	sequence :user do |n|
		{ :address => FactoryGirl.generate( :address ) ,
		:city => ["Springfield","Berkeley","Los Angeles","Palo Alto","Fagville"][rand(5)] ,
		:state => "California" ,
		:country => "United States of America" ,
		:zip => (1..5).map { rand(10) }.join ,
		:email => FactoryGirl.generate( :email ) ,
		:company => FactoryGirl.generate( :name ) ,
		:password => FactoryGirl.generate( :random_string ) }
	end # :user
	
	factory :item do |n|
		title FactoryGirl.generate( :random_string )
		description FactoryGirl.generate( :random_string )
		quantity { rand(500) }
		units "lbs"
	end # item	
	
	factory :user do |n|
		data = FactoryGirl.generate( :user )
		address data[:address]
		city data[:city]
		state data[:state]
		country data[:country]
		zip data[:zip]
		email data[:email]
		company data[:company]
		password data[:password]
	end # user
end # FactoryGirl.define

