require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :group_id
      String :event_name
      String :country_code
      Float :lat
      Float :lon
      String :city
    end
  end
end
