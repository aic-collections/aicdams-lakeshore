require 'rails_helper'

describe ExhibitionPresenter do
  it_behaves_like "a presenter with terms for a Citi resource"
  it_behaves_like "a presenter with related assets"
end
