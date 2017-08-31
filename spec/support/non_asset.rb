# frozen_string_literal: true
# A generic non-asset, or CITI resource such as an agent, work, exhibition, etc.
# This class is used in place of an actual non-asset when testing requires any type
# of non-asset and not a specific one.
class NonAsset < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors
end
