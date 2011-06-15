class API::Images < API::Base

  get "/map_icon" do
    canvas = Magick::Image.new(24,24) { self.background_color = "#434343" }
    canvas.format = 'gif'
    canvas.border!(1,1,'#fff')
    image = Magick::Draw.new
    image.gravity = Magick::CenterGravity
    image.pointsize = 14
    image.stroke = 'transparent'
    image.fill = '#ffffff'
    image.font_weight = Magick::BoldWeight
    image.font_family = 'Helvetica'
    image.annotate(canvas, 0, 0, 0, 0, params[:num])
    canvas.to_blob
  end

end