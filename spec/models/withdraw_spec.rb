# == Schema Information
#
# Table name: withdraws
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  amount      :decimal(, )
#  status      :string
#  card_number :string
#  comment     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Withdraw, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
