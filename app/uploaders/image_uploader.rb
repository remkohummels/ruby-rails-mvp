class ImageUploader < CommonUploader
  include CarrierWave::MiniMagick

  process :resize_to_limit => [700, nil]

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  version :listing do
    process :create_listing_version
  end

  version :small do
    process resize_to_fill: [50, 50]
  end

  def create_listing_version
    
    image = ::MiniMagick::Image::read(File.binread(@file.file))

    # resize images whose height or width is greater than 1000
    if image[:width] < 450 && image[:height] < 450
      resize_to_fill image[:width], image[:height]
    else
      if is_landscape?(image)
        # original is landscape
        width_scale_percent = 450.to_f/image[:width]
        height_scale = image[:height] * width_scale_percent
        resize_to_fill 450, height_scale
      else
        # original is portrait
        height_scale_percent = 450.to_f/image[:height]
        width_scale = image[:width] * height_scale_percent
        resize_to_fill width_scale, 450
      end
    end
  end

   # check image is landscape
  def is_landscape?(image)
      # Rails.logger.info "from in is_landscape? : #{image[:width] > image[:height]}"
      image[:width] > image[:height]
  end

  # check image is portrait
  def is_portrait?(new_file)
    # Rails.logger.info "from in is_portrait? : : #{ !is_landscape?(new_file)}"
    !is_landscape?(new_file)
  end

end
