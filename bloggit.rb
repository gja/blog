#! /usr/bin/env ruby

require 'square_bracket'
require 'restclient'
require 'cgi'

class BlogProcessor
  def fetch(url)
    $stderr.puts("Fetching #{url}")
    CGI.escapeHTML RestClient.get(url)
  end

  def gist(gist_id, file)
    <<-EOF
<script src="https://gist.github.com/#{gist_id}.js?file=#{file}"></script>
<noscript>
  <pre>#{fetch("https://raw.github.com/gist/#{gist_id}/#{file}")}</pre>
</noscript>
EOF
  end

  def footer(*args)
    Footer.new.render args
  end
end

class Footer
  BASE = <<-EOF
<hr />
<b>If you liked this post, you could:</b><br />
EOF

  def twitter(twitter_id)
    <<-EOF
<h4 style="text-align: center;">
  <a class="twitter-follow-button" data-show-count="false" href="https://twitter.com/#{twitter_id}">Follow @#{twitter_id}</a>
</h4>
EOF
  end

  def hacker_news(hacker_news_id)
    <<-EOF
<div style="text-align: center;">
  <b><a href="http://news.ycombinator.com/item?id=#{hacker_news_id}">upvote it</a> on Hacker News</b>
</div>
EOF
  end

  def components(args)
    [BASE] +
      args.map {|a| send(*a.split(':'))} +
      ["<br/>"]
  end

  def render(args)
    components(args).join "\n"
  end
end

file = ARGV[0] ? File.open(ARGV[0]) : $stdin
markdown = Redcarpet::Markdown.new(SquareBracket::HTMLRender.new(BlogProcessor.new), :autolink => true)
puts markdown.render file.read
