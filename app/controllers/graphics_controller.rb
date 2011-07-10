require 'RMagick'

class GraphicsController < ApplicationController
  caches_page :draw_icon

  def draw_icon
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
    send_data(canvas.to_blob, :type => "image/gif", :disposition => 'inline', :filename => "icon.gif")
  end

end