module Patch

  module Node

    extend self

    def all_from_spec(spec, options = {})
      spec = get_spec(spec)
      get_nodes(spec, :debug => options[:debug])
    end

    def modules
      @modules ||= {
        :midi => IO::MIDI,
        :osc => IO::OSC,
        :websocket => IO::Websocket
      }
    end

    private

    def get_spec(spec)
      spec_file = case spec
                  when File, String then spec
                  end
      case spec_file
      when nil then spec
      else YAML.load_file(spec_file)
      end
    end

    # All of the nodes from the spec
    def get_nodes(spec, options = {})
      node_array = spec[:nodes].map do |node|
        mod = modules[node[:type].to_sym]
        mod.new(node, :debug => options[:debug])
      end
      Nodes.new(node_array)
    end

  end
end