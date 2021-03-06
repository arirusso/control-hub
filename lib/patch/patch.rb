module Patch

  # A single patch consisting of a node mapping and actions
  class Patch

    attr_reader :actions, :maps, :name

    # @param [Symbol, String] name
    # @param [Array<Node::Map>, Node::Map] maps A node map or maps
    # @param [Array<Hash>, Hash] actions An action or actions
    def initialize(name, maps, actions)
      @name = name
      populate(maps, actions)
    end

    # Patch messages for the default values in the patch
    # @return [Array<Patch::Message>]
    def default_messages
      actions_with_default = @actions.select do |action|
        !action[:default].nil? && !action[:default][:value].nil?
      end
      actions_with_default.map do |action|
        value = action[:default][:value]
        index = @actions.index(action)
        Message.new(:index => index, :patch_name => @name, :value => value)
      end
    end

    # Enable the given nodes to implement this patch
    # @param [Node::Container] nodes
    # @return [Boolean]
    def enable
      result = @maps.map { |map| map.enable(self) }
      result.any?
    end

    private

    # Populate the patch
    # @param [Array<Hash, Node::Map>, Hash, Node::Map] maps
    # @param [Array<Hash>, Hash] actions
    # @return [Patch]
    def populate(maps, actions)
      populate_maps(maps)
      populate_actions(actions)
      self
    end

    # Populate the patch actions from various arg formats
    # @param [Array<Hash>, Hash] actions
    # @return [Array<Hash>]
    def populate_actions(actions)
      @actions = actions.kind_of?(Hash) ? [actions] : actions
    end

    # Populate the node maps from various arg formats
    # @param [Array<Hash, Node::Map>, Hash, Node::Map] maps
    # @return [Array<Node::Map>]
    def populate_maps(maps)
      maps = [maps] unless maps.kind_of?(Array)
      maps = maps.map do |map|
        if map.kind_of?(Hash)
          Node::Map.new(map.keys.first, map.values.first)
        else
          map
        end
      end
      @maps = maps.flatten.compact
    end

  end
end
