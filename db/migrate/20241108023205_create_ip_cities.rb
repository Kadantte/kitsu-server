class CreateIpCities < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_cities, id: false do |t|
      t.inet :start_ip, null: false
      t.inet :end_ip, null: false
      t.integer :geoname_id, null: false
      t.index [:start_ip, :end_ip]
    end
  end
end
