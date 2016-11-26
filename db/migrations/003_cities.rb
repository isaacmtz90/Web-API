require 'sequel'

Sequel.migration do
  change do
    create_table(:cities) do
      primary_key :id
      String :country_code
      Float :lat
      Float :lon
      String :name
    end
  end
end
