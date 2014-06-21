# libs
require "colorize"
require "em-websocket"
require "forwardable"
require "json"
require "midi"
require "osc-ruby"
require "osc-ruby/em_server"
require "scale"
require "socket"
require "yaml"

# modules
require "control-hub/controller"
require "control-hub/listener"

# classes
require "control-hub/config"
require "control-hub/debug"
require "control-hub/instance"

# patches
require "control-hub/patch"

module ControlHub

  VERSION = "0.1"

  def self.listen(*a)
    @instance = Instance.new(*a)
    @instance.listen
  end

end
