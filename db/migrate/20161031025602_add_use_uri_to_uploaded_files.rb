class AddUseUriToUploadedFiles < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :use_uri, :string
    add_index :uploaded_files, :use_uri
  end
end
