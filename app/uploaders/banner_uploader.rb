class BannerUploader < CommonUploader
  include CarrierWave::MiniMagick

  process :resize_to_fit => [1500, 350]
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  attr_reader :width, :height
  
  before :cache, :capture_size

  def capture_size(file)
    if version_name.blank? # Only do this once, to the original version
      if file.path.nil? # file sometimes is in memory
        img = ::MiniMagick::Image::read(file.file)
        @width = img[:width]
        @height = img[:height]
      else
        @width, @height = `identify -format "%wx %h" #{file.path}`.split(/x/).map{|dim| dim.to_i }
      end
    end
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

end
