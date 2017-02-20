# frozen_string_literal: true
class Lakeshore::AttachFilesToWorkJob < ActiveJob::Base
  queue_as :api
  include AddingFilesToWorks

  private

    def file_set_actor
      Lakeshore::Actors::FileSetActor
    end
end
