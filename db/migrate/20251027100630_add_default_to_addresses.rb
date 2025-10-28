class AddDefaultToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :is_default, :boolean, default: false, null: false
    add_index :addresses, %i[user_id is_default], unique: true, where: 'is_default = true',
                                                  name: 'index_addresses_on_user_id_default'
  end
end
