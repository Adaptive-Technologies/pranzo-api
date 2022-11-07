# require 'rsvg2'

module ImageConverter
  def self.svg_to_png(svg, width, height)
    svg = RSVG::Handle.new_from_data(svg)
    width   = width ||= 500
    height  = height ||= 500
    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
    context = Cairo::Context.new(surface)
    context.render_rsvg_handle(svg)
    b = StringIO.new
    surface.write_to_png(b) 
    base64 = Base64.encode64(b.string)
    "data:image/png;base64,#{base64}"
  end
end
