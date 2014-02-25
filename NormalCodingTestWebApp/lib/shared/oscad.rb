require 'RMagick'

module Oscad
  # TODO don't hard code this
  IMG_HOST = "192.168.1.3:3000"
  
  SCAD_FILE_NAME = File.join(Rails.root,"public","assets","scad","script.scad")
  SCAD_MODEL_FILE_NAME = File.join(Rails.root,"public","assets","scad","model.png")

  SCAD_MODEL_IMG_WIDTH = 200
  SCAD_MODEL_IMG_HEIGHT = 200

  SCAD_CMD = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o #{SCAD_MODEL_FILE_NAME} --imgsize=#{SCAD_MODEL_IMG_WIDTH},#{SCAD_MODEL_IMG_HEIGHT} #{SCAD_FILE_NAME}"
  
  BAR_GRAPH_WIDTH = 5
  BAR_GRAPH_MAX = 30
  
  RED_TEMPLATE_TOKEN = "RED_HEIGHT"
  GREEN_TEMPLATE_TOKEN = "GREEN_HEIGHT"
  BLUE_TEMPLATE_TOKEN = "BLUE_HEIGHT"
  
  SCAD_RGB_SCRIPT_TEMPATE = "
color(\"red\") {
  cube([#{BAR_GRAPH_WIDTH},#{BAR_GRAPH_WIDTH},#{RED_TEMPLATE_TOKEN}]);
}
color(\"green\") {
  translate([#{BAR_GRAPH_WIDTH*2},0,0]) {
    cube([#{BAR_GRAPH_WIDTH},#{BAR_GRAPH_WIDTH},#{GREEN_TEMPLATE_TOKEN}]);
  }
}

color(\"blue\") {
  translate([#{BAR_GRAPH_WIDTH*4},0,0]) {
    cube([#{BAR_GRAPH_WIDTH},#{BAR_GRAPH_WIDTH},#{BLUE_TEMPLATE_TOKEN}]);
  }
}
"

  # generates a simple bar graph based on the rgb values provided
  def self.generate_rgb_model!(img_file_path)
    img = Magick::Image.read(img_file_path).first
    
    red = green = blue = 0
    total_pixels = ((img.columns/5).to_i * img.rows).to_f
    
    # calculate average red, green, and blue on a 0-255 scale
    # only looks at every 5th pixel for speed
    img.rows.times do |row|
      (img.columns/5).to_i.times do |column|     
        pixel = img.pixel_color(row,column)
        red += pixel.red.to_f / 257 / total_pixels
        green += pixel.green.to_f / 257 / total_pixels
        blue += pixel.blue.to_f / 257 / total_pixels
      end
    end
    
    # convert to 0 - 30 scale for bar graph purposes
    red = ((red / 255) * 30).to_i
    green = ((green / 255) * 30).to_i
    blue = ((blue / 255) * 30).to_i
    
    script = SCAD_RGB_SCRIPT_TEMPATE.gsub(RED_TEMPLATE_TOKEN,red.to_s)
    script = script.gsub(GREEN_TEMPLATE_TOKEN,green.to_s)
    script = script.gsub(BLUE_TEMPLATE_TOKEN,blue.to_s)
    
    # generate the open scad script file for this rgb bar graph
    File.open(SCAD_FILE_NAME,"w") do |f|
      f.puts script
    end
    
    # assuming the command will succeed
    # TODO parse cmd output to determine if generating model failed and handle the error conditions
    res = system(SCAD_CMD)
    
    success = true
    
    # TODO dynamically insert host name instead of hard-coded
    return success ? "http://#{IMG_HOST}#{SCAD_MODEL_FILE_NAME.gsub(/.+public/,"")}" : nil
  end
end