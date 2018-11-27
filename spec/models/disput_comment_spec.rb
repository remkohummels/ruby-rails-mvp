# == Schema Information
#
# Table name: disput_comments
#
#  id         :integer          not null, primary key
#  disput_id  :integer
#  user_id    :integer
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe DisputComment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
