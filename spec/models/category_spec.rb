# == Schema Information
#
# Table name: categories
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Category do
  describe "functionality" do
  	before(:each) do
  		10.times do |k|
  			(@roots ||= []) << Category.create( :name => "faggot#{k}" )
  		end # times
  	end # before each
  	
  	[:roots].each do |functionality|
  		it "should respond to #{functionality}" do
  			Category.should respond_to functionality
  		end # it
  	end # each functionality
  	
  	[:parent, :children, :spawn].each do |functionality|
  		it "should respond to #{functionality}" do
  			@roots[rand(@roots.length)].should respond_to functionality
  		end # it
  	end # each functionality
  	
  	it "should create a new category" do
  		expect { @roots[0].spawn :name => "child" }.to change(Category, :count).by(1)
  	end # it
  	
  	it "should pull out all the roots" do
  		child = @roots[0].spawn :name => "faggot"
  		Category.roots.should eq @roots
  		Category.roots.should_not include child
  	end # it
  end # functionality
  
  describe "generations" do
  	before(:each) do
  		[:item, :material, :plastic, :hdpe, :regrind].each do |category|
  			(@categories ||= []) << (@categories.empty? ? Category.create( :name => category.to_s ) : @categories.last.spawn( :name => category.to_s ))
  		end # each category
  		@generations = lambda do |category, depth|
  			return category if depth == 0 || category.parent.nil?
  			return @generations.call( category.parent, depth-1 )
  		end # generations
  	end # before each
  	
  	it "should not be making up bullshit" do
  		@categories.each { |cate| cate.should_not be_false }
  	end # it
  	it "should be properly related" do
  		@categories.count.times do |k|
  			@generations.call( @categories.last, k ).should eq @categories.reverse[k]
  		end # times k
  	end # it
  	
  end # generations
  describe "field" do
  	before(:each) do
  		2.times { |m| ( @roots ||= [] ) << Category.create( :name => "root#{m}" ) }
  		@roots.each do |root|
				10.times do |n|
					(( @children ||= {} )[root] ||= [] ) << root.spawn( :name => "child#{n}for#{root.name}" )
				end # 10 times
			end # each root
			
  	end # before each
  	
  	2.times do |k|
  	
  		it "should pull out the correct children" do
  			@roots[k].children.should eq @children[@roots[k]]
  		end # it
  		
  		it "should not pull out other people's children" do
  			@children[@roots[k]].each do |child|
  				@roots[ (k+1)%2 ].children.should_not include child
  			end # each child
  		end # it
  	end # 2times
  	
  end # field
  
end # Category
