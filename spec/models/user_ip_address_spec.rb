# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserIPAddress, type: :model do
  subject { build(:user_ip_address) }

  it { is_expected.to belong_to(:user).required }
end
