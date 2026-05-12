require 'fastimage'

# 定义需要检查的图片扩展名
EXTENSIONS = %w[jpg jpeg png].freeze

def check_image_ratios
  # 获取当前文件夹下所有匹配扩展名的文件
  image_files = Dir.glob("*").select do |file|
    ext = File.extname(file).downcase.delete('.')
    EXTENSIONS.include?(ext)
  end

  if image_files.empty?
    puts "当前文件夹下没有找到 jpg 或 png 图片。"
    return
  end

  invalid_images = []

  image_files.each do |file|
    size = FastImage.size(file)
    
    if size
      width, height = size
      # 使用交叉相乘 (w * 9 == h * 16) 来避免浮点数精度问题
      # 如果比例不是 16:9，则加入无效列表
      unless width * 9 == height * 16
        invalid_images << "#{file} (#{width}x#{height})"
      end
    else
      puts "警告: 无法读取图片尺寸: #{file}"
    end
  end

  if invalid_images.empty?
    puts 'Perfect'
  else
    puts "以下图片比例不是 16:9:"
    invalid_images.each { |img| puts img }
  end
end

if __FILE__ == $0
  check_image_ratios
end
