#! /usr/bin/env ruby

require 'optparse'
require 'redcarpet'
require 'restclient'
require 'cgi'

class Bloggit < Redcarpet::Render::HTML
  def initialize(options)
    super
    @hacker_news_id = options[:hacker_news]
  end

  def fetch(url)
    $stderr.puts("Fetching #{url}")
    CGI.escapeHTML RestClient.get(url)
  end

  def replace_gists(document)
    document.gsub(/\[gist (.*) (.*)\]/) do
      gist_id = $1
      file = $2
      <<-EOF
<script src="https://gist.github.com/#{gist_id}.js?file=#{file}"></script>
<noscript>#{fetch("https://raw.github.com/gist/#{gist_id}/#{file}")}</noscript>
EOF
    end
  end

  def hacker_news_snippet
    @hacker_news_id.nil? ? "" :  <<-EOF
<div style="text-align: center;">
  <b><a href="http://news.ycombinator.com/item?id=#{@hacker_news_id}">upvote it</a> on Hacker News</b>
</div>
EOF
  end

  def doc_footer
    <<-EOF
<hr />
<b>If you liked this post, you could:</b><br />
<h4 style="text-align: center;">
  <a class="twitter-follow-button" data-show-count="false" href="https://twitter.com/tdinkar">Follow @tdinkar</a>
</h4>
#{hacker_news_snippet}
<br/>
EOF
  end

  def postprocess(full_document)
    methods = []# [:replace_gists]
    methods.inject(full_document) { |d, m| send(m, d) }
  end
end

render_opts = {:with_toc_data => true}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: blogit input.md [--hacker-news 4194066]"
  opts.on('-hn', '--hacker-news ID', "Link to hacker news") do |id| 
    render_opts[:hacker_news] = id
  end
end
optparse.parse!

file = ARGV[0] ? File.open(ARGV[0]) : $stdin
markdown = Redcarpet::Markdown.new(Bloggit.new(render_opts), :autolink => true)
puts markdown.render file.read
