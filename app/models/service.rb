# == Schema Information
#
# Table name: services
#
#  company     :string(255)      default("Tracago"), not null
#  created_at  :datetime         not null
#  description :string(255)      not null
#  id          :integer          not null, primary key
#  price       :integer          default(0), not null
#  title       :string(255)      not null
#  updated_at  :datetime         not null
#

class Service < ActiveRecord::Base
  attr_accessible :company, :description, :price, :title
end
