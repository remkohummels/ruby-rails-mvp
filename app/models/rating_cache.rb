# == Schema Information
#
# Table name: rating_caches
#
#  id             :integer          not null, primary key
#  cacheable_id   :integer
#  cacheable_type :string
#  avg            :float            not null
#  qty            :integer          not null
#  dimension      :string
#  created_at     :datetime
#  updated_at     :datetime
#

class RatingCache < ActiveRecord::Base
  belongs_to :cacheable, :polymorphic => true
end
