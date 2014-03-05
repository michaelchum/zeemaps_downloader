require 'csv'
require 'open-uri'
require 'fileutils'

PATH_TO_CSV_FILE = "ZeeMap-748667.csv"
PATH_TO_IMAGE_DIRECTORY = "pictures"

content = CSV.read(PATH_TO_CSV_FILE, encoding: "ISO8859-1") # IMPORTANT Change encoding to ISO for proper rendering

# There are some youtube videos, .gif and .odt files however we only want .png and .jpg files
accepted_formats = [".jpg", ".png", ".JPG", ".PNG"]

# Check if image folder exists. If not, create
unless File.directory? (PATH_TO_IMAGE_DIRECTORY)
  FileUtils.mkdir_p(PATH_TO_IMAGE_DIRECTORY)
end

locations = {}

content[1..content.length].each do |row|
  if row[8] != nil and accepted_formats.include? File.extname(row[8])
    ext = File.extname(row[8])
    url = URI.encode("http:" + row[8])
    row[3] ? name = row[3] + "_" : name = "None" + "_"
    row[4] ? name += row[4] + "_" : name += "None" + "_"
    row[5] ? name += row[5] : name += "None"

    if locations.key? name
      locations[name] = (locations[name].to_i + 1).to_i
    else
      locations[name] = 0
    end

    unless locations[name].to_i == 0
      name += "_" + locations[name].to_s
    end
    
    name += ext
      path_name = PATH_TO_IMAGE_DIRECTORY + "/" + name
      puts path_name
      open(path_name, 'wb') do |file|
        begin
          file << open(url).read
        rescue
          break
        end
    end
  end
end
