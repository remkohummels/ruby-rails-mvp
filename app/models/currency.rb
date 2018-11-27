# == Schema Information
#
# Table name: currencies
#
#  id         :integer          not null, primary key
#  name       :string
#  course     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Currency < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  has_many :users
  after_initialize :check_currency, if: 'self.updated_at'
  
  SITE_CURRENCY = 'USD'

  def expired?
    if self.updated_at
      self.updated_at < Time.now.yesterday
    end
  end

  def short_country_name
    short_names = {
      USD: 'us',
      EUR: 'eu',
      CAD: 'ca',
      GBP: 'gb'
    }

    short_names[self.name.to_sym]
  end

  def sign
    signs = {
      USD: '$',
      EUR: '€',
      CAD: 'C$',
      GBP: '£'
    }
    signs[self.name.to_sym]
  end

  def convert(usd_amount)
    usd_amount = 0 if usd_amount.nil?
    self.sign + ' ' + number_with_delimiter(number_with_precision(usd_amount * self.course, precision: 2)).to_s
  end

  def self.get_by_country(country_code)
    if country_code == 'CA'
      name = 'CAD'
    elsif country_code == 'GB'
      name = 'GBP'
    elsif %w(AT BE CY EE FI FR DE GR IE IT LV LT LU MT NL PT SK SI ES).include? country_code
      name = 'EUR'
    else
      name = 'USD'
    end
    Currency.find_by(name: name)
  end

  private

  def check_currency
    if self.expired? && (self.name != SITE_CURRENCY)
      service = CurrencyService.new
      course = service.convert_to(SITE_CURRENCY, self.name)
      if course
        self.course = course
        self.save
      end
    end
    if self.name == SITE_CURRENCY
      self.course = 1
    end
  end
end
