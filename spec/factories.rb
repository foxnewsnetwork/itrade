FactoryGirl.define do
	
	sequence :email do |n|
		"testdrone#{n}@test.com"
	end # email
	
	sequence :name do |n|
		"Alice McTest#{n}"
	end # name
	
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
	
	factory :item do |n|
		title FactoryGirl.generate( :random_string )
		description FactoryGirl.generate( :random_string )
		quantity { rand(500) }
		units "lbs"
	end # item	
end # FactoryGirl.define

