require 'sequel'

Sequel.migration do
  up do
    add_column :events, :description, String
  end
  down do
    drop_column :events, :description
  end
end
