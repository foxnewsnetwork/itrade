# == Schema Information
#
# Table name: users
#
#  admin                  :boolean          default(FALSE)
#  company                :string(255)      default(""), not null
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  extention              :string(255)
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  location_id            :integer
#  phone                  :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :phone, :password, :password_confirmation, :remember_me, :company, :extension
  
  # Relationships
  has_many :items, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  belongs_to :location
  
  # Validations
  validates :company, :uniqueness => true, :length => { :in => 2..255 }
  validates :phone, :presence => true, :format => { :with => /\d{10,18}/ }
  
  # Custom Modules
  include Location::Locateable
  
  # Callbacks
  before_validation do |user|
  	user.company = user.company.strip.downcase.squeeze(" ").gsub( /[^a-zA-Z0-9 ]/, "" ) 
		user.phone = user.phone.strip.gsub( /\D/,"" )
  end # before_validation
  
  def bid( bid_data, item_id )
  	b = self.bids.new( bid_data )
  	b.item_id = item_id
  	return b if b.save
  	return nil
  end # bid
  
  # here for ducking purposes
  def user
  	self
  end # user
end # User
