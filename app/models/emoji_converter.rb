class EmojiConverter
  def initialize(url)
    @url = url
  end

  def data
    image.to_blob
  end

  def content_type
    image.mime_type
  end

  private

  attr_reader :url, :image

  def image
    @image ||= build_image
  end

  def build_image
    image = MiniMagick::Image.open(url)

    unless image.width == image.height
      crop_size = [image.width, image.height].min
      x_delta = (image.width - crop_size) / 2
      y_delta = (image.height - crop_size) / 2
      image.crop("#{crop_size}x#{crop_size}+#{x_delta}+#{y_delta}")
    end

    image.resize("125x125")
  end
end
