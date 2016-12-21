# frozen_string_literal: true
# Using our own version of Sufia::CatalogSearchBuilder
class CatalogSearchBuilder < Sufia::CatalogSearchBuilder
  private

    # Override Sufia::CatalogSearchBuilder to actually use edismax instead of dismax
    def dismax_query
      "{!edismax v=$user_query}"
    end
end
