module FixtureLoader
  def load_fedora_fixture(ttl, index = true)
    data = File.read(ttl)
    id = SecureRandom.hex(16)
    url = fedora_url(id)
    ActiveFedora.fedora.connection.put(url, data)
    ActiveFedora::Base.find(id).update_index if index
  end

  def fedora_fixture(file)
    File.join(fixture_path, file)
  end

  private

    def fedora_url(id)
      base = id[0..7]
      base.insert(2, "/").insert(5, "/").insert(8, "/")
      id.insert(8, "-").insert(13, "-").insert(18, "-").insert(23, "-")
      [ActiveFedora.config.credentials[:url], ActiveFedora.config.credentials[:base_path], base, id].join("/")
    end
end
