#!/usr/bin/env ruby

require 'webrick'
require 'webrick/httpproxy'
require 'stringio'
# require 'uri'

handler = proc do |req, res|
  content_after = " CA"
  content_before = "CB "
  add_to_content_length = "#{content_after}#{content_before}".size.to_i

  res.header['content-length'] = (res.header['content-length'].to_i + add_to_content_length).to_s

  compose = lambda do |add_first, original_body|
    proc do |sock|
      original_body.(add_first.(sock))
      sock.write content_after
    end
  end

  add_before = lambda { |sock| sock.write content_before; sock}

  res.body = compose.(add_before,res.body)
end

proxy = WEBrick::HTTPProxyServer.new Port: 8080, ProxyContentHandler: handler

trap 'INT'  do proxy.shutdown end
trap 'TERM' do proxy.shutdown end

proxy.start


# require 'webrick'
# require 'webrick/httpproxy'
# # require 'stringio'
# # require 'uri' no needed

# handler = proc do |req, res|
#   content_body = <<-HTML
#   <body>
#     Custom Html
#   <body>
#   HTML

#   res.header['content-length'] = content_body.size.to_s

#   res.body = content_body if req.request_uri.host =~ /local/
# end

# proxy = WEBrick::HTTPProxyServer.new Port: 8080, ProxyContentHandler: handler

# trap 'INT'  do proxy.shutdown end
# trap 'TERM' do proxy.shutdown end

# proxy.start