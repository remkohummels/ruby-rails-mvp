# == Schema Information
#
# Table name: disputs
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  reason         :string
#  description    :string
#  status         :string
#  winner_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#  resolve_reason :text
#

require 'rails_helper'

RSpec.describe Disput, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
