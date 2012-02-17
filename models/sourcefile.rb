# encoding: utf-8

class Sourcefile
  attr_reader :raw_text, :lines, :header
  
  def initialize(text)
    sanitize_text(text)
    @raw_text = text
    @lines = @raw_text.split("\n")
    if @lines.first =~ /^diff --git/
      line = ""
      header_lines = []
      @lines.reverse!
      until line =~ /^@@ [^@]* @@/
        line = @lines.pop
        header_lines << line
      end
      @lines.reverse!
      @header = header_lines.join("\n")
    end
  end
  
  private
    def sanitize_text(text)
      text.encode!('UTF-16LE', 'UTF-8', :invalid => :replace, :replace => '')
      text.encode!('UTF-8', 'UTF-16LE')
    end
end