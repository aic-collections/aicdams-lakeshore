# frozen_string_literal: true
require 'mini_magick'
require 'open3'

module Hydra::Derivatives::Processors
  class Image < Processor
    include ShellBasedProcessor
    include Open3
    class_attribute :timeout

    def process
      timeout ? process_with_timeout : determine_whether_to_resize_image
    end

    def process_with_timeout
      Timeout.timeout(timeout) { determine_whether_to_resize_image }
    rescue Timeout::Error
      raise Hydra::Derivatives::TimeoutError, "Unable to process image derivative\nThe command took longer than #{timeout} seconds to execute"
    end

    protected

      # Check the image type and label. If we're creating an access file from a pdf,
      # simply copy original to directive url; otherwise, proceed with creating the resized image.
      def determine_whether_to_resize_image
        if label == :access && pdf? && format == "pdf"
          output_file = directives.fetch(:url).split('file:')[1]
          begin
            _stdin, _stdout, _stderr = popen3("cp #{source_path} #{output_file}")
          rescue StandardError => e
            Rails.logger.error("#{self.class} copy error: #{e}")
          end
        else
          create_resized_image
        end
      end

      # When resizing images, it is necessary to flatten any layers, otherwise the background
      # may be completely black. This happens especially with PDFs. See #110
      # MiniMagick::Tool::Convert is used directly because `gm mogrify` does not support -flatten.
      def create_resized_image
        create_image do |xfrm|
          if size
            MiniMagick::Tool::Convert.new do |cmd|
              cmd << xfrm.path # input
              cmd.flatten
              cmd.resize(size)
              cmd << xfrm.path # output
            end
          end
        end
      end

      def create_image
        xfrm = selected_layers

        xfrm.density(300) if format == "jp2" && pdf?
        yield(xfrm) if block_given?
        xfrm.format(directives.fetch(:format))
        xfrm.quality(quality.to_s) if quality
        write_image(xfrm)
      end

      # Use Graphicsmagick command to adjust access jp2 files. This ensures they are in the correct format.
      def execute_mogrify_commands(output_file:, arguments:)
        Image.execute("#{File.join(ENV['hydra_bin_path'], 'gm')} mogrify #{arguments} #{output_file}")
      rescue StandardError => e
        Rails.logger.error("#{self.class} mogrify error. #{e}")
      end

      def write_image(xfrm)
        output_io = StringIO.new
        xfrm.write(output_io)
        output_io.rewind
        str = output_file_service.call(output_io, directives)

        if mogrify?
          execute_mogrify_commands(output_file: directives[:url].split("file:")[1], arguments: add_sharpening)
        end
        str
      end

      # Override this method if you want a different transformer, or need to load the
      # raw image from a different source (e.g. external file)
      def image
        @image ||= MiniMagick::Image.open(source_path)
      end

    private

      def mogrify?
        (directives[:url].include?("access") && directives[:url].include?("jp2")) || directives[:url].include?("citi")
      end

      def add_sharpening
        directives[:url].include?("citi") ? "-sharpen 1,.5" : ""
      end

      def size
        directives.fetch(:size, nil)
      end

      def quality
        directives.fetch(:quality, nil)
      end

      def format
        directives.fetch(:format, nil)
      end

      def label
        directives.fetch(:label, nil)
      end

      def pdf?
        (image.type =~ /pdf/i) == 0
      end

      def layers?
        directives.fetch(:layer, nil).present?
      end

      def selected_layers
        if pdf?
          image.layers[directives.fetch(:layer, 0)]
        elsif layers?
          image.layers[directives.fetch(:layer)]
        else
          image
        end
      end
  end
end
