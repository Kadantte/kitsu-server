class CreateGeonames < ActiveRecord::Migration[6.1]
  def change
    create_table :geonames, id: false do |t|
      t.integer :geoname_id, primary_key: true
      t.string :continent_code
      t.string :continent_name
      t.string :country_iso_code
      t.string :country_name
      t.string :subdivision_1_iso_code
      t.string :subdivision_1_name
      t.string :subdivision_2_iso_code
      t.string :subdivision_2_name
      t.string :city_name
    end
  end
end
