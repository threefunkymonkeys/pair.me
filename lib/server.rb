require 'rubygems'
require 'em-websocket'

EventMachine.run do
  @channels = {}

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|
    ws.onopen do

      puts ws.request.inspect

      ws.onmessage do |msg|
        case(msg)
        when /create/
          channel = EM::Channel.new
          sid = channel.subscribe{ |message| ws.send message }
          @channels[sid] = channel
          ws.send "{channel: #{sid}}"

        when /join (.+)/
          sid = $1.to_i
          channel = @channels[sid]
          ws.send "{action: join, sid: #{sid}, channel: #{channel.inspect}}"
          channel.push "Incoming Connection"
          channel.subscribe{ |message| ws.send message }

        when /msg (\d) (.+)/
          sid = $1.to_i
          channel = @channels[sid]
          channel.push $2
        end

        ws.send "ACK #{msg}"
      end

      ws.onclose do
        ws.send "Good bye"
      end
    end

  end

  puts "Server Started"
end
