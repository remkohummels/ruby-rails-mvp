# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  status                 :string           default("active")
#  first_name             :string
#  last_name              :string
#  role                   :string
#  balance                :decimal(, )      default(0.0)
#  password_reset_token   :string
#  password_reset_sent_at :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  website                :string
#  country                :string
#  phone                  :string
#  about                  :text
#  provider               :string
#  uid                    :string
#  referral               :string
#  city                   :string
#  community              :string
#  currency_id            :integer          default(1)
#  avatar_url             :string
#  state                  :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
