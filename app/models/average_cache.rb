# == Schema Information
#
# Table name: average_caches
#
#  id            :integer          not null, primary key
#  rater_id      :integer
#  rateable_id   :integer
#  rateable_type :string
#  avg           :float            not null
#  created_at    :datetime
#  updated_at    :datetime
#

class AverageCache < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true
end
