# == Schema Information
#
# Table name: ports
#
#  city       :string(255)
#  code       :string(255)
#  created_at :datetime         not null
#  domestic   :boolean          default(TRUE), not null
#  id         :integer          not null, primary key
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Port do
  pending "add some examples to (or delete) #{__FILE__}"
end
