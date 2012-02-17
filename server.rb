require 'sinatra'
require 'rest-client'
require './models/sourcefile'

get "/styles/style.css" do
  content_type "text/css"
  sass :styles
end

get "/" do
  @source = params[:f]
  @contents = resolve_sourcefile(@source)
  
  if @contents
    haml :diff
  else
    haml :index
  end
end

private
  def resolve_sourcefile(f)
    return nil unless f
    contents = get_file(f)
    if contents
      source = Sourcefile.new(contents)
      return source
    else
      return nil
    end
  end
  
  def get_file(f)
    begin
      source = RestClient.get(f)
      return source.body
    rescue
      return nil
    end
  end