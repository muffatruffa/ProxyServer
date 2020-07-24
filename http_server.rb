#!/usr/bin/env ruby

require 'webrick'

server = WEBrick::HTTPServer.new(
    :Port => 8000,
)

server.mount_proc '/' do |req, res|
  res.body = "Example Domain Cleartext\n"
end

server.start