require 'rubygems'
require 'sinatra'
require 'haml'
require 'RMagick'

# Helpers
# require './lib/render_partial'

# Set Sinatra variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, 'views'
set :public_folder, 'public'
set :haml, {:format => :html5}

FORMATS = {
  "png" => "png",
  "gif" => "gif",
  "jpg" => "jpeg"
}
#Application routes
get '/' do
  haml :index
end

# get '/:color1/:color2/:color3/:color4/:color5' do
get '/:color1' do
  begin
    # TODO grab the format and size from somewhere
    format = FORMATS[format] || 'png'
    height = 100
    width = 100

    imgs = make_imageList(params[:color1])
    content_type "image/#{format}"
    img = imgs.append(false)
    img.format = format
    img.to_blob

  rescue Exception => e
    "<p>Something broke.  You can try <a href='/200x200'>this simple test</a>. If this error occurs there as well, you are probably missing app dependencies. Make sure RMagick is installed correctly. If the test works, you are probably passing bad params in the url.</p><p>Use this thing like http://host:port/200x300, or add color and textcolor params to decide color.</p><p>Error is: [<code>#{e}</code>]</p>"
  end

end
get '/:color1/:color2' do
  format = FORMATS[format] || 'png'
  imgs = make_imageList(params[:color1], params[:color2])
  content_type "image/#{format}"
  img = imgs.append(false)
  img.format = format
  img.to_blob
end
get '/:color1/:color2/:color3' do
  format = FORMATS[format] || 'png'
  imgs = make_imageList(params[:color1], params[:color2], params[:color3])
  content_type "image/#{format}"
  img = imgs.append(false)
  img.format = format
  img.to_blob
end
get '/:color1/:color2/:color3/:color4' do
  format = FORMATS[format] || 'png'
  imgs = make_imageList(params[:color1], params[:color2], params[:color3], params[:color4])
  content_type "image/#{format}"
  img = imgs.append(false)
  img.format = format
  img.to_blob
end
get '/:color1/:color2/:color3/:color4/:color5' do
  format = FORMATS[format] || 'png'
  imgs = make_imageList(params[:color1], params[:color2], params[:color3], params[:color4], params[:color5])
  content_type "image/#{format}"
  img = imgs.append(false)
  img.format = format
  img.to_blob
end

private

def make_imageList(color1="#BADA55", color2="transparent", color3="transparent", color4="transparent", color5="transparent", width=100, height=100)
  imgs = Magick::ImageList.new
  imgs.new_image(width, height) { self.background_color = color1 }
  imgs.new_image(width, height) { self.background_color = color2 }
  imgs.new_image(width, height) { self.background_color = color3 }
  imgs.new_image(width, height) { self.background_color = color4 }
  imgs.new_image(width, height) { self.background_color = color5 }
  return imgs
end

def color_convert(original)
  if original
    if original.index('!') == 0
      original.tr('!', '#')
    else
      original
    end
  end
end
