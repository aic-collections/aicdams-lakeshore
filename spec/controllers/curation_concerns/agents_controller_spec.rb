# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::AgentsController do
  let(:user) { create(:user1) }
  include_context "authenticated saml user"
  it_behaves_like "#index redirects to catalog facet search"
end
