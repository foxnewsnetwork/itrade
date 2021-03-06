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

class Category < ActiveRecord::Base
  attr_accessible :name
  
  # relationships
  has_many :children, :class_name => "Category", :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :foreign_key => :parent_id, :class_name => "Category"
  
  # pre-hooks
  before_save do |category|
  	category.name = category.name.strip.downcase.gsub( /(\s|\W)/, "" )
  end # before_save
  
	def spawn( child_data = nil )
		self.children.create( child_data )
	end # spawn
	
	def self.roots
		Category.where( :parent_id => nil )
	end # self.roots
end # Category
