# frozen_string_literal: true
# Calculates the dimensions of the access master give the dimensions of the original
class DimensionsService
  attr_reader :original_width, :original_height

  def initialize(dimensions)
    @original_height = dimensions.fetch(:height)
    @original_width = dimensions.fetch(:width)
  end

  # @return [Array<Integer>] resized x and y values
  def adjusted_ratio
    @adjusted_ratio ||= AspectRatio.resize(original_width, original_height, 3000, 3000, false)
  end

  def width
    adjusted_ratio.first
  end

  def height
    adjusted_ratio.last
  end
end
