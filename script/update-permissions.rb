# Reads in csv file and updates permissions
# @example To update all the assets in a csv granting department 246 edit access:
#   bundle exec rails runner script/update-permissions.rb file.csv 246

class PermissionFile
  attr_reader :path

  def initialize(path = ARGV[0])
    @path = path
  end

  def assets
    rows.map(&:last).uniq
  end

  private

    def rows
      @rows ||= CSV.read(path, col_sep: "\t")
    end
end

PermissionFile.new.assets.each do |uid|
  AddEditGroupPermissionJob.perform_later(uid: uid, group: ARGV[1])
end
