class CreateIpasns < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_asns, id: false do |t|
      t.inet :start_ip, null: false
      t.inet :end_ip, null: false
      t.integer :autonomous_system_number, null: false
      t.string :autonomous_system_organization, null: false
      t.index [:start_ip, :end_ip]
    end
  end
end
