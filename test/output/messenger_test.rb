require "helper"

class ControlHub::Output::MessengerTest < Test::Unit::TestCase

  include ControlHub

  context "Messenger" do

    setup do
      @socket = Object.new
      @messenger = Output::Messenger.new(@socket)
    end

    context "#in" do

      setup do
        @message = { :value => "blah", :timestamp => 1396406728702 }.to_json
        @result = @messenger.in(@message)
      end

      should "convert from String to Hash" do
        assert_not_nil @result
        assert_equal Hash, @result.class
        assert_equal "blah", @result[:value]
      end

      should "convert timestamp from js time to ruby" do
        timestamp = @result[:timestamp]
        assert_not_nil timestamp
        assert_equal Time, timestamp.class
        assert_equal 2014, timestamp.year
        assert_equal 4, timestamp.month
        assert_equal 22, timestamp.hour
      end
      
    end

    context "#new_timestamp" do

      should "be js int time format" do
        result = @messenger.send(:new_timestamp)
        assert_not_nil result
        assert_equal Fixnum, result.class
        assert result.to_s.size > Time.new.to_i.to_s.size
        assert_equal (result / 1000).to_s.size, Time.new.to_i.to_s.size
      end

    end

    context "#out" do

      setup do
        @message = { :statement => "something" }
      end

      should "not overwrite timestamp" do
        @socket.expects(:send).once
        ts = Time.now.to_i / 1000
        @message[:timestamp] = ts
        @messenger.out(@message)
        assert_equal ts, @message[:timestamp]
      end

      should "generate new timestamp" do
        @socket.expects(:send).once
        @messenger.out(@message)
        assert_not_nil @message[:timestamp]
        assert_equal Fixnum, @message[:timestamp].class
      end

      should "return nil if fails" do
        messenger = Output::Messenger.new(nil)
        result = messenger.out(@message)
        assert_nil result
      end

      should "return json string if success" do
        @socket.expects(:send).once
        result = @messenger.out(@message)
        assert_not_nil result
        assert_equal String, result.class
      end

    end

  end

end