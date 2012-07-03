#! /usr/bin/env ruby

require 'redcarpet'

file = ARGV[0] ? File.open(ARGV[0]) : STDIN

class Bloggit < Redcarpet::Render::HTML
  def postprocess(full_document)
    full_document.
      gsub(/\[gist (.*) (.*)\]/, '<script src="https://gist.github.com/\1.js?file=\2"></script>')
  end
end

markdown = Redcarpet::Markdown.new(Bloggit.new)
puts markdown.render file.read
