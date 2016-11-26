require 'sequel'

Sequel.migration do
  change do
    create_table(:groups) do
      primary_key :id
      String :group_name
      String :country_code
      String :city
    end
  end
end
