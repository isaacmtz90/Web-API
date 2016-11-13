require 'sequel'

Sequel.migration do
  up do
    add_column :events, :time, DateTime
    add_column :events, :type, String
  end
  down do
    drop_column :events, :time
    drop_column :events, :type
  end
end
