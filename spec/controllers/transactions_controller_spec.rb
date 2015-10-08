require 'rails_helper'

describe TransactionsController do
  it_behaves_like "a controller for a Citi resource", "transaction"
end
