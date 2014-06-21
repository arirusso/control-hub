require "helper"

class ControlHub::Output::ServerTest < Test::Unit::TestCase

  include ControlHub

  context "Server" do

    setup do
      @control = File.join(__dir__,"../config/control.yml")
      @io = File.join(__dir__,"../config/io.yml")
      @config = ControlHub::Config.new(:control => @control, :io => @io)
      @server = ControlHub::Output::Server.new(@config)
    end

    context "#enable" do

      setup do
        @server.expects(:configure).once
        @server.send(:enable, nil)
      end
      
      should "populate messenger" do
        assert_not_nil @server.messenger
        assert_equal ControlHub::Output::Messenger, @server.messenger.class
      end

    end

    context "#act" do

      setup do
        @server.expects(:configure).once
        EM::WebSocket.stubs(:run).yields(Object.new)
      end
      
      should "fail quietly when messenger hasn't been initialized" do
        assert_nil @server.messenger
        assert_nothing_raised(Exception) { @server.act(:hi => "hello") }
      end

      should "send when messenger is available" do
        @server.send(:enable, nil)
        @server.messenger.expects(:out).once
        assert_nothing_raised(Exception) { @server.act(:hi => "hello") }
      end

    end

  end

end
