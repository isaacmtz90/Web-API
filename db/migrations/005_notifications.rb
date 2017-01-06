require 'sequel'

Sequel.migration do
  change do
    create_table(:notifications) do
      primary_key :id
      foreign_key :event_id
      String :to
      String :from
      String :event_name
    end
  end
end
