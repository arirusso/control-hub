module ControlHub

  module Output

    class Server

      attr_reader :messenger

      def initialize(config, options = {})
        @config = config.io[:controller]
        @messenger = nil
        @socket = nil
        @debug = options[:debug]
      end

      def act(message)
        @messenger.out(message) if !@messenger.nil?
      end

      def start
        Thread.abort_on_exception = true
        EM::WebSocket.run(@config) { |ws| enable(ws) }
      end

      private

      # Enable this server after initializing an EM::Websocket
      def enable(ws)
        @socket = ws
        @messenger = Messenger.new(@socket, :debug => @debug)
        configure
      end

      def configure
        @socket.onopen do |handshake|
          puts "Connection open"
        end

        @socket.onclose do 
          puts "Connection closed"
        end

        @socket.onmessage do |raw_message|
          message = @messenger.in(raw_message)
          @debug.puts("Recieved message: #{message.to_json}") if @debug
        end
      end

    end
  end
end