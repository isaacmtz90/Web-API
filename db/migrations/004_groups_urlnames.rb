require 'sequel'

Sequel.migration do
  up do
    add_column :groups, :urlname, String
  end
  down do
    drop_column :groups, :urlname
  end
end
