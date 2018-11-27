# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  file       :string
#  temp_key   :string
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# require 'file_size_validator'
class Image < ActiveRecord::Base
  belongs_to :item, counter_cache: true
  validates :file, file_size: { less_than_or_equal_to: 5.megabytes }
  mount_uploader :file, ImageUploader
end
