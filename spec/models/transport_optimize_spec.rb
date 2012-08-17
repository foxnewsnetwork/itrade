require 'spec_helper'
require 'factories'

describe Ship do
	describe "best ship" do
		before(:each) do
			@yard = Factory(:yard)
			@foreign_port = Port.create Factory.next(:port).merge(:domestic => false)
			10.times do |n|
				(@ports ||= []) << Factory(:port, :domestic => true)
				(@ships ||= []) << Factory(:ship, :price => n).from(@ports.last).to( @foreign_port )
				(@trucks ||= []) << Factory(:truck, :price => n).from( @yard ).to(@ports.last)
			end # 10 times
			@sql_statement = %Q(
				SELECT niggers.*, faggots.* FROM trucks AS niggers
				INNER JOIN targets AS truckstarts ON truckstarts.t_id = '#{@yard.id}' AND truckstarts.t_type = 'yard'
				INNER JOIN targets AS shipfinishes ON shipfinishes.t_id = '#{@foreign_port.id}' AND shipfinishes.t_type = 'port'
				INNER JOIN ships AS faggots ON faggots.finish = shipfinishes.id
				INNER JOIN targets AS truckfinishes ON truckfinishes.id = niggers.finish AND truckfinishes.t_type = 'port'
				INNER JOIN targets AS shipstarts ON shipstarts.id = faggots.start AND shipstarts.t_type = 'port' 
				WHERE shipstarts.t_id = truckfinishes.t_id AND shipstarts.t_type = truckfinishes.t_type
				ORDER BY (niggers.price + faggots.price) ASC
			)
			@sql_statement2 = %Q(
				SELECT s.id AS s_id, s.price AS s_price, s.finish AS s_finish,  
				t.id AS t_id, t.price AS t_price, t.start AS t_start, t.finish AS exchange
				FROM trucks AS t
				INNER JOIN targets AS truckstarts ON truckstarts.t_id = '#{@yard.id}' AND truckstarts.t_type = 'yard'
				INNER JOIN targets AS shipfinishes ON shipfinishes.t_id = '#{@foreign_port.id}' AND shipfinishes.t_type = 'port'
				INNER JOIN ships AS s ON s.finish = shipfinishes.id
				INNER JOIN targets AS truckfinishes ON truckfinishes.id = t.finish AND truckfinishes.t_type = 'port'
				INNER JOIN targets AS shipstarts ON shipstarts.id = s.start AND shipstarts.t_type = 'port' 
				WHERE shipstarts.t_id = truckfinishes.t_id AND shipstarts.t_type = truckfinishes.t_type
				ORDER BY (s.price + t.price) ASC
			)
			# @results = Ship.connection.select_all(@sql_statement)
			@flags = {}
			Ship.connection.select_all(@sql_statement2).each do |result|
				if @flags[ "#{result['s_id']}-#{result['t_id']}" ].nil?
					(@results ||= []) << result
				end # if flags
				@flags[ "#{result['s_id']}-#{result['t_id']}" ] ||= true
			end # each result
		end # before each
		it "should be a foreign port" do
			@foreign_port.domestic.should be_false
		end # it
		it "should still work" do
			@results.count.should eq 10
			price = -1
			@results.each do |result|
				price.should <= result['s_price'] + result['t_price']
				price = result['s_price'] + result['t_price']
				# puts result
			end # each result
		end # it
		[Ship, Truck].each do |trans|
			it "should work as a function" do
				trans.find_by_best_routes( :origin => @yard, :destiny => @foreign_port ).should eq @results
			end # it
		end # each trans
		it "should not pull 2384290384 records that are duplicates from the database" do
			pending "Please Pass this Test"
		end # it
	end # best ship
end # ship
