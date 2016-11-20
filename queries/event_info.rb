# TODO: Define ths query with geo info
# # Search query for postings in a group by optional keywords
# class EventInfoQuery
#   def self.call(search_terms)
#     search_terms&.any? ? search_events(event, search_terms) : event
#   end
#
#   private_class_method
#
#   def self.search_events(search_terms)
#     Posting.where(where_clause(search_terms), event_id: event.id).all
#   end
#
#   def self.where_clause(search_terms)
#     search_terms.map do |term|
#       Sequel.ilike(:event_name, "%#{term}%")
#     end.inject(&:|)
#   end
# end
