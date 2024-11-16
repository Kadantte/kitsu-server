# frozen_string_literal: true

class IPCity < ApplicationRecord
  belongs_to :geoname

  def self.matching_ip(ip)
    where('start_ip <= ? AND end_ip >= ?', ip.to_s, ip.to_s)
  end
end
