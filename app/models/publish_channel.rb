# frozen_string_literal: true
class PublishChannel < Definition
  private

    def term
      @term ||= AICPublishChannel.find_term(id)
    end
end
