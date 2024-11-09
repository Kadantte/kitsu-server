# frozen_string_literal: true

class UserIpAddress < ApplicationRecord
  belongs_to :user, optional: false

  validates :ip_address, presence: true

  def asn
    IPASN.find_by('start_ip <= ? AND end_ip >= ?', ip_address.to_s, ip_address.to_s)
  end

  def city
    IPCity.find_by('start_ip <= ? AND end_ip >= ?', ip_address.to_s, ip_address.to_s)
  end
end
