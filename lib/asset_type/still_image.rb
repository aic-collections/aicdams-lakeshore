# frozen_string_literal: true
module AssetType
  class StillImage < Base
    def self.all
      ["application/pdf",
       "image/jpeg",
       "image/png",
       "image/tiff",
       "image/jpf",
       "image/x-adobe-dng"]
    end
  end
end
