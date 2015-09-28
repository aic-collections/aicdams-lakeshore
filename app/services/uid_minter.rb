class UidMinter

  attr_reader :prefix

  # @param [String] prefix two-letter prefix indicating the type of resource
  def initialize(prefix)
    @prefix = prefix
  end

  # Returns a unique identifier with a two-letter prefix and six digits
  # @return [String] such as "TX-123456"
  def mint
    return mock_id unless Rails.env.production?
    uid_from_database
  end

  def uid_from_database
    response = new_uid
    response.rows.map { |r| r.first }.first
  end

  private

    # Because the process of creating a new uid is tied to a database stored procedure that only exists 
    # on specific servers, a mock method is provided for testing and development purposes.
    def mock_id
      [prefix, rand.to_s[2..7]].join("-")
    end

    # Calls the stored procedure defined in the Uid model to create a new uid.
    # @return [ActiveRecord::Result]
    def new_uid
      Uid.mint_uid(prefix)
    end

end
