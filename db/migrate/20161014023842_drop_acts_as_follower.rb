# This feature was part of earlier versions of Sufia, but was removed in version 7.2
class DropActsAsFollower < ActiveRecord::Migration
  def change
    drop_table :follows
  end
end
