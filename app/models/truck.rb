# == Schema Information
#
# Table name: trucks
#
#  company    :string(255)      not null
#  created_at :datetime         not null
#  finish     :integer
#  id         :integer          not null, primary key
#  price      :integer          default(0), not null
#  start      :integer
#  updated_at :datetime         not null
#

class Truck < ActiveRecord::Base
	include Transport
	Transport.transportable Truck
end # Truck
