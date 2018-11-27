# == Schema Information
#
# Table name: faq_items
#
#  id         :integer          not null, primary key
#  question   :string
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FaqItem < ActiveRecord::Base
end
