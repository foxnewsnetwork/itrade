# == Schema Information
#
# Table name: users
#
#  address                :string(255)      not null
#  admin                  :boolean          default(FALSE)
#  city                   :string(255)      not null
#  company                :string(255)      default(""), not null
#  country                :string(255)      default(""), not null
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  state                  :string(255)      default(""), not null
#  updated_at             :datetime         not null
#  zip                    :string(255)      default(""), not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :phone, :password, :password_confirmation, :remember_me
  attr_accessible :address, :city, :company, :country, :state, :zip
  
  # Relationships
  has_many :items, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  
  # Validations
  ['address','city','state','country','phone','company','zip'].each do |field|
  	validates field, :presence => true
  end # each field
  validates :company, :uniqueness => true
  
  # Callbacks
  before_save { |user| user.company = user.company.strip.downcase.squeeze(" ").gsub( /[^a-zA-Z0-9 ]/, "" ) }
  
  def bid( bid_data, item_id )
  	b = self.bids.new( bid_data )
  	b.item_id = item_id
  	return b if b.save
  	return nil
  end # bid
end # User
