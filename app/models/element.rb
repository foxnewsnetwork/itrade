# == Schema Information
#
# Table name: elements
#
#  created_at           :datetime         not null
#  id                   :integer          not null, primary key
#  item_id              :integer
#  metadata             :string(255)
#  picture_content_type :string(255)
#  picture_file_name    :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  updated_at           :datetime         not null
#

class Element < ActiveRecord::Base
  # Attributes
  attr_accessible :item_id, :metadata, :picture
  
  # Relationships
  belongs_to :item
  
  # Attachments (be sure to change these for S3 environment in production)
  has_attached_file :picture, :styles => { :small => "50x50>", :thumb => "260x180" } ,
    :url => "/images/elements/:id/:style/:basename.:extension" ,
    :path => ":rails_root/public/images/elements/:id/:style/:basename.:extension"
    
  # Validations
  validates_attachment_presence :picture
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_content_type :picture, :content_type => ['image/png', 'image/gif', 'image/jpg','image/jpeg']
end # Element
