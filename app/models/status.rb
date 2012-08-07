# == Schema Information
#
# Table name: statuses
#
#  created_at :datetime         not null
#  effect     :string(255)
#  id         :integer          not null, primary key
#  item_id    :integer          not null
#  name       :string(255)      default("incomplete"), not null
#  updated_at :datetime         not null
#

class Status < ActiveRecord::Base
  # Attributes
  attr_accessible :effect, :name
  
  # Relationships
  belongs_to :item
end # Status
