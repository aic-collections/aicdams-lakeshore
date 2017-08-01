# frozen_string_literal: true
# Calculates the dimensions of the access master give the dimensions of the original
class DimensionsService
  attr_reader :original_width, :original_height

  # @param [String] original_height
  # @param [String] original_width
  def initialize(dimensions)
    @original_height = dimensions.fetch(:height)
    @original_width = dimensions.fetch(:width)
  end

  # @return [Integer, nil]
  def width
    return unless original_width && original_height
    adjusted_ratio.first
  end

  # @return [Integer, nil]
  def height
    return unless original_width && original_height
    adjusted_ratio.last
  end

  private

    # @return [Array<Integer>] resized x and y values
    def adjusted_ratio
      @adjusted_ratio ||= AspectRatio.resize(original_width, original_height, 3000, 3000, false)
    end
end
