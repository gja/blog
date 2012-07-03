#! /usr/bin/env ruby

require 'redcarpet'
require 'restclient'

file = ARGV[0] ? File.open(ARGV[0]) : STDIN

class Bloggit < Redcarpet::Render::HTML
  def replace_gists(document)
    document.gsub(/\[gist (.*) (.*)\]/) do
      gist_id = $1
      file = $2
      <<-EOF
<script src="https://gist.github.com/#{gist_id}.js?file=#{file}"></script>
<noscript>#{RestClient.get("https://raw.github.com/gist/#{gist_id}/#{file}")}</noscript>
EOF
    end
  end

  def postprocess(full_document)
    [:replace_gists].inject(full_document) { |d, m| send(m, d) }
  end
end

markdown = Redcarpet::Markdown.new(Bloggit.new)
puts markdown.render file.read
