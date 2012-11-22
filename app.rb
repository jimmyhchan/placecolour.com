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

get '/:size' do
  begin
    wh, format = params[:size].downcase.split('.')
    format = FORMATS[format] || 'png'
    width, height = wh.split('x').map { |wat| wat.to_i }
    height = width unless height
    imgs = Magick::ImageList.new 
    imgs.new_image(width, height) { self.background_color = "red" }
    imgs.new_image(width, height) { self.background_color = "yellow" }
    imgs.new_image(width, height) { self.background_color = "green" }

    content_type "image/#{format}"
    img = imgs.append(false)
    img.format = format
    img.to_blob

  rescue Exception => e
    "<p>Something broke.  You can try <a href='/200x200'>this simple test</a>. If this error occurs there as well, you are probably missing app dependencies. Make sure RMagick is installed correctly. If the test works, you are probably passing bad params in the url.</p><p>Use this thing like http://host:port/200x300, or add color and textcolor params to decide color.</p><p>Error is: [<code>#{e}</code>]</p>"
  end

end

private

def color_convert(original)
  if original
    if original.index('!') == 0
      original.tr('!', '#')
    else
      original
    end
  end
end
