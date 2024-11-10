# frozen_string_literal: true

class IPFilter < ApplicationRecord
  enum type: {
    asn: 1,
    city: 2,
    country: 3
  }
  flag :actions, %i[
    validate_email_before_posting
    block_posting
    delay_posting
  ]

  scope :by_asn, ->(asn) { where(type: :asn, pattern: asn) }
  scope :by_city, ->(city) { where(type: :city, pattern: city) }
  scope :by_country, ->(country) { where(type: :country, pattern: country) }

  def self.actions_by_ip(ip)
    asn = IPASN.find_by('start_ip <= ? AND end_ip >= ?', ip.to_s, ip.to_s).autonomous_system_number
    geoname = IPCity.find_by('start_ip <= ? AND end_ip >= ?', ip.to_s, ip.to_s).geoname
    country = geoname.country_iso_code
    city = geoname.geoname_id

    # HACK: Make ourselves an ActiveFlag::Value object without a model instance
    IPFilter.actions.to_value(nil,
      by_asn(asn)
        .or(by_city(city))
        .or(by_country(country))
        .pluck(:actions).reduce(0, :|))
  end
end
