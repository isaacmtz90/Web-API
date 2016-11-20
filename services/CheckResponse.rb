# frozen_string_literal: true

# check whether group already exists in database
class CheckResponse
  extend Dry::Monads::Either::Mixin

  def self.call(response, countrycode, locationtext)
    parsed_response = JSON.parse(response.to_json)
    if parsed_response.first['country'] != countrycode.upcase
      Left(Error.new(:not_found, "Groups at#{countrycode} at#{locationtext} not found!"))
    else
      Right() # do nothing!
    end
  end
end
