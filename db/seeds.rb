# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rubygems'
require 'faker'

@categories = ['plastics','metals','precious metals','semiconductors','nonmetals']
@types = { 
	"plastics" => ['HPDE','LPDE','PP','PET'],
	"metals" => ['iron','copper'],
	"precious metals" => ['gold','silver','bronze'] ,
	"semiconductors" => [:silicon, :germanium],
	"nonmetals" => [:coal, :graphite]
} # types
@countries = [ 'USA','China','Japan','Korea','Mexico','Canada','Cuba']
@titles = ['twine','ropes','binds','purge','regrind','dogshit']

def get( something )
	something[rand(something.count)]
end # get

@categories.each do |category|
	c = Category.create( :name => category )
	@types[category].each do |type|
		c.spawn( :name => type )
	end # each type 
end # each category



