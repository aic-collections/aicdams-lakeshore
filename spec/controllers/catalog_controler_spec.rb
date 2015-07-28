require 'rails_helper'

describe CatalogController do

  context "as a public user" do
    describe "searching works" do

      let!(:work) do
        Work.create.tap do |w|
          w.title = ["Famous painting"]
          w.artist_display = ["Joe Artist"]
          w.save
        end
      end

      it "find works with a title" do
        get :index, q: 'Famous painting'
        expect(response).to be_success
        expect(assigns(:document_list).count).to eq 1
        expect(assigns(:document_list).map(&:id)).to eq [work.id]
      end

      it "find works with a artist" do
        get :index, q: 'Joe Artist'
        expect(response).to be_success
        expect(assigns(:document_list).count).to eq 1
        expect(assigns(:document_list).map(&:id)).to eq [work.id]
      end

    end

  end

end
