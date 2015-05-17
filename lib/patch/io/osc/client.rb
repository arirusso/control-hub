module Patch

  module IO

    module OSC

      # OSC Client
      class Client

        attr_reader :id

        # @param [String] host
        # @param [Fixnum] port
        # @param [Hash] options
        # @option options [Fixnum] :id
        # @option options [Log] :log
        def initialize(host, port, options = {})
          @log = options[:log]
          @client = ::OSC::Client.new(host, port)
          @id = options[:id]
        end

        # Convert message objects to OSC and send
        # @param [::Patch::Patch] patch
        # @param [Array<Patch::Message, ::OSC::Message>, ::OSC::Message, Patch::Message] messages Message(s) to send
        # @return [Array<::OSC::Message>]]
        def puts(patch, messages)
          messages = [messages].flatten
          osc_messages = messages.map do |message|
            osc_message = ::Patch::IO::OSC::Message.to_osc_messages(patch, message) unless message.kind_of?(::OSC::Message)
            osc_message ||= message
            osc_message
          end
          osc_messages.each { |osc_message| @client.send(osc_message) }
          osc_messages
        end

      end

    end

  end

end