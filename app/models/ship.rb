# == Schema Information
#
# Table name: ships
#
#  company    :string(255)      not null
#  created_at :datetime         not null
#  finish     :integer
#  id         :integer          not null, primary key
#  price      :integer          default(0), not null
#  start      :integer
#  updated_at :datetime         not null
#

class Ship < ActiveRecord::Base
	include Transport
	Transport.transportable Ship
end # Ship
