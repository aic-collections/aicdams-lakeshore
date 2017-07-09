namespace :authorities do
  desc "Migrates old pre-1.1.5 status authorities to their new format"
  task migrate: :environment do
    # Update the hasModel predicate from StatusType to ListItem for each status uri
    ids = ["ST--2", "ST--1", "ST-0", "ST-1", "ST-2"]
    existing_ids = []
    ids.each do |id|
      hash_id = service.hash(id)
      if ActiveFedora::Base.exists?(hash_id)
        sparql_update(ActiveFedora::Base.id_to_uri(hash_id))
        existing_ids << hash_id
      end
    end
    # Add the existing list items to the list's membership predicate
    list.members = existing_ids.map { |id| ActiveFedora::Base.find(id) }
    list.save
  end

  desc "Breaks the new status uris (for testing only)"
  task break: :environment do
    # Remove any existing list items from the list's membership predicate
    ["ST--2", "ST--1", "ST-0", "ST-1", "ST-2"].each do |item|
      list.members.delete(ActiveFedora::Base.find(service.hash(item)))
    end

    # Break some, but not all, of the list items
    ids = ["ST--2", "ST--1", "ST-0"]
    ids.each do |id|
      hash_id = service.hash(id)
      sparql_break(ActiveFedora::Base.id_to_uri(hash_id)) if ActiveFedora::Base.exists?(hash_id)
    end
  end

  def sparql_update(uri)
    query = "PREFIX myfcrmodel: <info:fedora/fedora-system:def/model#>" \
            "DELETE { <> myfcrmodel:hasModel \"StatusType\" }" \
            "INSERT { <> myfcrmodel:hasModel \"ListItem\" }" \
            "WHERE  { }"
    ActiveFedora.fedora.connection.patch(uri, query, "Content-Type" => "application/sparql-update")
  rescue Ldp::BadRequest
    puts "#{uri} does not have hasModel StatusType"
  end

  def sparql_break(uri)
    query = "PREFIX myfcrmodel: <info:fedora/fedora-system:def/model#>" \
            "DELETE { <> myfcrmodel:hasModel \"ListItem\" }" \
            "INSERT { <> myfcrmodel:hasModel \"StatusType\" }" \
            "WHERE  { }"
    ActiveFedora.fedora.connection.patch(uri, query, "Content-Type" => "application/sparql-update")
  rescue Ldp::BadRequest
    puts "#{uri} didn't break"
  end

  def service
    @service ||= UidMinter.new
  end

  def list
    @list ||= List.find_by_uid("LS-1")
  end
end
