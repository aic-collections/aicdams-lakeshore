# frozen_string_literal: true
# Defines a fileset actor for Lakeshore that uses a sub-classed FileActor
class Lakeshore::Actors::FileSetActor < CurationConcerns::Actors::FileSetActor
  def file_actor_class
    Lakeshore::Actors::FileActor
  end
end
