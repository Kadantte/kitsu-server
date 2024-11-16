# frozen_string_literal: true

RSpec.describe IPFilter do
  let(:mountain_view) do
    Geoname.create!(
      geoname_id: 5_375_480,
      continent_code: 'NA',
      continent_name: 'North America',
      country_iso_code: 'US',
      country_name: 'United States',
      subdivision_1_iso_code: 'CA',
      subdivision_1_name: 'California',
      city_name: 'Mountain View'
    )
  end

  describe '#by_ip' do
    context 'with an ASN filter' do
      before do
        IPASN.create!(
          start_ip: '8.8.8.8',
          end_ip: '8.8.8.8',
          autonomous_system_number: 69_420,
          autonomous_system_organization: 'Nice Company, LLC'
        )
      end

      let(:filter) do
        described_class.create!(
          type: :asn,
          pattern: '69420',
          actions: %i[block_posting]
        )
      end

      it 'includes the filter if the IP is in the ASN' do
        expect(described_class.by_ip('8.8.8.8')).to include(filter)
      end

      it 'does not include the filter if the IP is not in the ASN' do
        expect(described_class.by_ip('9.9.9.9')).not_to include(filter)
      end
    end

    context 'with a city filter' do
      before do
        IPCity.create!(
          start_ip: '8.8.8.8',
          end_ip: '8.8.8.8',
          geoname: mountain_view
        )
      end

      let(:filter) do
        described_class.create!(
          type: :city,
          pattern: mountain_view.geoname_id,
          actions: %i[block_posting]
        )
      end

      it 'includes the filter if the IP is in the city' do
        expect(described_class.by_ip('8.8.8.8')).to include(filter)
      end

      it 'does not include the filter if the IP is not in the city' do
        expect(described_class.by_ip('9.9.9.9')).not_to include(filter)
      end
    end

    context 'with a country filter' do
      before do
        IPCity.create!(
          start_ip: '8.8.8.8',
          end_ip: '8.8.8.8',
          geoname: mountain_view
        )
      end

      let(:filter) do
        described_class.create!(
          type: :country,
          pattern: 'US',
          actions: %i[block_posting]
        )
      end

      it 'includes the filter if the IP is in the country' do
        expect(described_class.by_ip('8.8.8.8')).to include(filter)
      end

      it 'does not include the filter if the IP is not in the country' do
        expect(described_class.by_ip('9.9.9.9')).not_to include(filter)
      end
    end
  end

  describe '#take_action?' do
    it 'returns true if the actions are present in the Relation' do
      described_class.create!(
        type: :asn,
        pattern: '69420',
        actions: %i[block_posting]
      )
      expect(described_class.asn.where(pattern: '69420').take_action?(:block_posting)).to eq(true)
    end
  end

  describe '#applicable_actions' do
    it 'returns all matching actions in the Relation as an ActiveFlag::Value' do
      described_class.create!(
        type: :asn,
        pattern: '69420',
        actions: %i[block_posting]
      )
      described_class.create!(
        type: :city,
        pattern: mountain_view.geoname_id,
        actions: %i[require_email_validation]
      )

      expect(described_class.applicable_actions).to include(:block_posting)
      expect(described_class.applicable_actions).to include(:require_email_validation)
      expect(described_class.applicable_actions).to be_a(ActiveFlag::Value)
    end
  end
end
