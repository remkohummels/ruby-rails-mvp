# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string
#  slug           :string
#  priority       :integer
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  image          :string
#  color          :string
#  static_image   :string
#

class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  mount_uploader :image, CategoryImgUploader
  acts_as_nested_set
  has_many :items, dependent: :destroy
  default_scope { order(priority: 'asc') }
  acts_as_list :column => :priority

  def childrens
    Category.where(parent_id: self.id)
  end

  def get_current_and_chield_ids
    category_ids = Category.where(parent_id: self.id).pluck(:id)
    category_ids.push self.id 
  end

  def self.ordered_list
    Category.where.not(name: 'Other').reorder(:name).to_a << Category.where(name: 'Other').first
  end
end
