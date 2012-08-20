# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rubygems'

@domestic_ports = [
{:city=>"LA", :code=>"Port of South Louisiana"} ,
{:city=>"OR", :code=>"Portland-OR"} ,
{:city=>"TN", :code=>"Nashville"} ,
{:city=>"LA", :code=>"New Orleans"} ,
{:city=>"WA", :code=>"Kalama"} ,
{:city=>"MO", :code=>"Kansas City"} ,
{:city=>"LA", :code=>"Baton Rouge"} ,
{:city=>"WA", :code=>"Vancouver"} ,
{:city=>"OR", :code=>"Coos Bay"} ,
{:city=>"LA", :code=>"Port of Plaquemines"} ,
{:city=>"WA", :code=>"Longview"} ,
{:city=>"TN", :code=>"Chattanooga"} ,
{:city=>"LA", :code=>"Morgan City"} ,
{:city=>"OR", :code=>"Astoria"} ,
{:city=>"MS", :code=>"Greenville"} ,
{:city=>"LA", :code=>"Avondale"} ,
{:city=>"CA", :code=>"Richmond-CA"} ,
{:city=>"AL", :code=>"Guntersville"} ,
{:city=>"TX", :code=>"Houston"} ,
{:city=>"CA", :code=>"Oakland"} ,
{:city=>"GA", :code=>"Brunswick"} ,
{:city=>"TX", :code=>"Texas City"} ,
{:city=>"CA", :code=>"San Francisco"} ,
{:city=>"VA", :code=>"Richmond-VA"} ,
{:city=>"TX", :code=>"Freeport"} ,
{:city=>"CA", :code=>"Carquinez Srt."} ,
{:city=>"VA", :code=>"Hopewell"} ,
{:city=>"TX", :code=>"Galveston"} ,
{:city=>"CA", :code=>"San Pablo Bay"} ,
{:city=>"OK", :code=>"Tulsa"} ,
{:city=>"LA", :code=>"Lake Charles"} ,
{:city=>"CA", :code=>"Martinez"} ,
{:city=>"AR", :code=>"Helena"} ,
{:city=>"TX", :code=>"Beaumont"} ,
{:city=>"CA", :code=>"Selby"} ,
{:city=>"CA", :code=>"San Diego"} ,
{:city=>"TX", :code=>"Port Arthur"} ,
{:city=>"CA", :code=>"Alameda"} ,
{:city=>"CA", :code=>"Port Hueneme"} ,
{:city=>"TX", :code=>"Orange"} ,
{:city=>"AL", :code=>"Mobile"} ,
{:city=>"CA", :code=>"Ventura"} ,
{:city=>"NY/NJ", :code=>"Port of NY/NJ"} ,
{:city=>"MD", :code=>"Baltimore"} ,
{:city=>"PR", :code=>"Ponce"} ,
{:city=>"PA", :code=>"Philadelphia"} ,
{:city=>"MS", :code=>"Pascagoula"} ,
{:city=>"Virgin Islands", :code=>"Christiansted"} ,
{:city=>"NJ", :code=>"Paulsboro"} ,
{:city=>"MS", :code=>"Biloxi"} ,
{:city=>"VI", :code=>"St. Croix"} ,
{:city=>"PA", :code=>"Marcus Hook"} ,
{:city=>"MS", :code=>"Gulfport"} ,
{:city=>"Virgin Islands", :code=>"Charlotte Amaile"} ,
{:city=>"DE", :code=>"New Castle"} ,
{:city=>"IL", :code=>"St. Louis"} ,
{:city=>"VI", :code=>"St. Thomas"} ,
{:city=>"NJ", :code=>"Camden-Gloucester City"} ,
{:city=>"FL", :code=>"Port Everglades"} ,
{:city=>"DE", :code=>"Wilmington-DE"} ,
{:city=>"FL", :code=>"Miami"} ,
{:city=>"NJ", :code=>"Trenton"} ,
{:city=>"FL", :code=>"Palm Beach"} ,
{:city=>"PA", :code=>"Chester"} ,
{:city=>"FL", :code=>"Ft. Lauderdale"} ,
{:city=>"PA", :code=>"Morrisville"} ,
{:city=>"WV", :code=>"Huntington"} ,
{:city=>"NJ", :code=>"Burlington"} ,
{:city=>"MA", :code=>"Boston"} ,
{:city=>"TX", :code=>"Corpus Christi"} ,
{:city=>"MA", :code=>"New Bedford"} ,
{:city=>"TX", :code=>"Matagorda"} ,
{:city=>"HI", :code=>"Honolulu"} ,
{:city=>"TX", :code=>"Victoria"} ,
{:city=>"HI", :code=>"Barbers Pt."} ,
{:city=>"TX", :code=>"Brownsville"} ,
{:city=>"FL", :code=>"Jacksonville"} ,
{:city=>"TX", :code=>"Port Lavaca"} ,
{:city=>"MI", :code=>"Detroit"} ,
{:city=>"CA", :code=>"Long Beach"} ,
{:city=>"OH", :code=>"Cleveland"} ,
{:city=>"CA", :code=>"Los Angeles"} ,
{:city=>"TN", :code=>"Memphis"} ,
{:city=>"AK", :code=>"Valdez"} ,
{:city=>"GA", :code=>"Savannah"} ,
{:city=>"IL", :code=>"Chicago"} ,
{:city=>"SC", :code=>"Charleston"} ,
{:city=>"IN", :code=>"Indiana Harbor"} ,
{:city=>"OH", :code=>"Toldeo"} ,
{:city=>"IN", :code=>"Burns Intl. Harbor"} ,
{:city=>"MI", :code=>"Monroe"} ,
{:city=>"IN", :code=>"Gary"} ,
{:city=>"ME", :code=>"Portland-ME"} ,
{:city=>"MI", :code=>"Port Inland"} ,
{:city=>"OH", :code=>"Lorain"} ,
{:city=>"IN", :code=>"Buffington"} ,
{:city=>"PR", :code=>"San Juan"} ,
{:city=>"IN", :code=>"East Chicago"} ,
{:city=>"OH", :code=>"Cincinnati"} ,
{:city=>"VA", :code=>"Norfolk"} ,
{:city=>"MI", :code=>"St. Clair"} ,
{:city=>"VA", :code=>"Newport News"} ,
{:city=>"MI", :code=>"Marine City"} ,
{:city=>"MN/WI", :code=>"Duluth/Superior"} ,
{:city=>"MI", :code=>"Marysville"} ,
{:city=>"MN", :code=>"Two Harbors"} ,
{:city=>"MI", :code=>"Port Huron"} ,
{:city=>"MN", :code=>"Silver Bay"} ,
{:city=>"AK", :code=>"Nikiski"} ,
{:city=>"MI", :code=>"Drummond Island"} ,
{:city=>"AK", :code=>"Anchorage"} ,
{:city=>"MI", :code=>"Sault Ste Marie"} ,
{:city=>"KY", :code=>"Louisville"} ,
{:city=>"WA", :code=>"Seattle"} ,
{:city=>"NC", :code=>"Wilmington-NC"} ,
{:city=>"WA", :code=>"Tacoma"} ,
{:city=>"MN", :code=>"St. Paul"} ,
{:city=>"WA", :code=>"Anacortes"} ,
{:city=>"MN", :code=>"Minneapolis"} ,
{:city=>"FL", :code=>"Tampa"} ,
{:city=>"IN", :code=>"Mt. Vernon"} ,
{:city=>"FL", :code=>"St. Petersburg"} ,
{:city=>"MS", :code=>"Vicksburg"} ,
{:city=>"PA", :code=>"Pittsburgh"} ,
{:city=>"NC", :code=>"Morehead City"}
]
@foreign_ports = [ 
{:city=>"India", :code=>"Mumbai"} ,
{:city=>"India", :code=>"JNPT"} ,
{:city=>"India", :code=>"Chennai"} ,
{:city=>"India", :code=>"Kolkata"} ,
{:city=>"India", :code=>"Kandla"} ,
{:city=>"India", :code=>"Paradip"} ,
{:city=>"India", :code=>"Vishakapatnam"} ,
{:city=>"India", :code=>"Tuticorin"} ,
{:city=>"Indonesia", :code=>"Tanjung Priok"} ,
{:city=>"Japan", :code=>"Hakodate"} ,
{:city=>"Japan", :code=>"Tokyo"} ,
{:city=>"Japan", :code=>"Yokohama"} ,
{:city=>"Japan", :code=>"Nagoya"} ,
{:city=>"Japan", :code=>"Osaka"} ,
{:city=>"Japan", :code=>"Kobe"} ,
{:city=>"Kuwait", :code=>"Ash Shu'aybah Port"} ,
{:city=>"Kuwait", :code=>"Mina Abdullah"} ,
{:city=>"Malaysia", :code=>"Port Klang"} ,
{:city=>"Malaysia", :code=>"Tanjung Pelepas"} ,
{:city=>"China", :code=>"Hong Kong"} ,
{:city=>"China", :code=>"Shanghai"} ,
{:city=>"China", :code=>"Suzhou"} ,
{:city=>"China", :code=>"Ningbo"} ,
{:city=>"China", :code=>"Qingdao"} ,
{:city=>"China", :code=>"Yantai"} ,
{:city=>"China", :code=>"Tianjin"} ,
{:city=>"China", :code=>"Qinhuangdao"} ,
{:city=>"China", :code=>"Guangzhou"} ,
{:city=>"China", :code=>"Shenzhen"} ,
{:city=>"China", :code=>"Zhuhai"} ,
{:city=>"China", :code=>"Xiamen"} ,
{:city=>"China", :code=>"Dalian"} ,
{:city=>"China", :code=>"Yingkou"} ,
{:city=>"Philippines", :code=>"Subic"} ,
{:city=>"Philippines", :code=>"Manila"} ,
{:city=>"Philippines", :code=>"Iloilo"} ,
{:city=>"Philippines", :code=>"Cebu"} ,
{:city=>"Philippines", :code=>"Davao"} ,
{:city=>"Russia", :code=>"Vladivostok"} ,
{:city=>"Singapore", :code=>"Singapore"} ,
{:city=>"North Korea", :code=>"Wonsan"} ,
{:city=>"South Korea", :code=>"Busan"} ,
{:city=>"South Korea", :code=>"Incheon"} ,
{:city=>"Sri Lanka", :code=>"Colombo"} ,
{:city=>"Sri Lanka", :code=>"Hambantota"} ,
{:city=>"Sri Lanka", :code=>"Galle"} ,
{:city=>"Sri Lanka", :code=>"Trincomalee"} ,
{:city=>"Taiwan", :code=>"Kaohsiung"} ,
{:city=>"Taiwan", :code=>"Keelung"} ,
{:city=>"Taiwan", :code=>"Taichung"} ,
{:city=>"Taiwan", :code=>"Hualien"} ,
{:city=>"United Arab Emirates", :code=>"Jebel Ali"} ,
{:city=>"United Arab Emirates", :code=>">>Vietnam"} ,
{:city=>"United Arab Emirates", :code=>"Ho Chi Minh City"} ,
{:city=>"United Arab Emirates", :code=>"Haiphong"}
]

def yard
{ 
	:street_address => Faker::Address.street_address ,
	:city => Faker::Address.city ,
	:state => Faker::Address.state ,
	:zip => Faker::Address.zip_code	
}
end # location

def port(where = :domestic)
{ 
	:city => Faker::Address.city ,
	:code => Faker::Name.last_name + rand(999999999).to_s ,
	:domestic => where == :domestic ? true : false
}
end # port

def get1( duck )
	duck[rand(duck.count)]
end # get1

@ports = { true => [], false => [] }
{@domestic_ports => true, @foreign_ports => false}.each do |ports, domestic|
	ports.each do |port|
		@ports[domestic] << Port.create( port.merge( :domestic => domestic ) )
	end # each port
end # each ports

@domestic = @ports[true]
@foreign = @ports[false]
@companies = [ 'Maersk','Cosco','Yangming','CMA CGM','K Line','Hapag-Llyod','China Shippping', 'OOCL', 'MSC', 'TMMLines']
@domestic.each do |domestic|
	@foreign.each do |foreign|
		Ship.new( :company => get1(@companies), :price => 300 + rand(600) ).from( domestic ).to( foreign ).save
	end # each foreign
end # each domestic
3.times do 
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
		:maw => rand(234345) ,
		:color => "white" ,
		:contamination => "none"
	) # item
	( @item_locations  ||= []) << ( Yard.create yard )
	@item.at @item_locations.last
end # 10 users
20.times do
	( @item_locations  ||= []) << ( Yard.create yard )
end # 100.times
20.times do
	Truck.new(
		:company => get1(['KKW Trucking', 'Perez Brothers','P&R Trucking','Schneider National','Knights Transportation','Duncan and Sons Lines']) ,
		:price => 50 + rand(200) ,
	).from(get1 @item_locations).to(get1 @domestic).save # ship
end # auxiliaries

Service.create( :company => "Tracago!", :title => "CCIC", :description => "Necessary inspection for goods traveling to China", :price => 150 )
@stuffes = { 
	'scrap plastic' => [ 'LDPE','HDPE','PP','PET','PVC','Nylon','Rubber','ABS','PS','MISC'] ,
	'common metals' => ['Iron','Copper','Mercury'] ,
	'semiconductor' => ['Silicon','Germanium','Arsenic']
}
@stuffes.each do |key, val|
	@category = Category.create( :name => key )
	val.each do |a|
		@category.spawn( :name => a )
	end # each a
end # each key val

