require "helper"

class Patch::IO::MIDITest < Test::Unit::TestCase

  include Patch

  context "MIDI" do

    context "Input" do

      setup do
        @action_file = File.join(__dir__,"../config/action.yml")
        @nodes_file = File.join(__dir__,"../config/nodes.yml")
        @nodes = Patch::Nodes.new(@nodes_file)
        @action = Patch::Action.new(@action_file)
        @input = @nodes.find_all_by_type(:midi).first
        @input.action = @action.find_all_by_type(:midi)
      end

      context "#initialize" do

        should "have id" do
          assert_not_nil @input.id
        end
        
        should "have midi input" do
          assert_not_nil @input
        end

        should "initialize midi listener" do
          assert_not_nil @input.instance_variable_get("@listener")
        end

        should "create control mapping" do
          assert_not_nil @input.instance_variable_get("@action")
        end

      end

      context "#start" do

        should "start listener" do
          ::MIDIEye::Listener.any_instance.expects(:run)
          @input.start
        end

      end

      context "#handle_event_received" do

        setup do
          @message = MIDIMessage::ControlChange.new(0, 0x01, 0x30)
        end

        should "perform scaling on value" do
          scale = Object.new
          Scale.expects(:transform).once.returns(scale)
          scale.expects(:from).once.returns(scale)
          scale.expects(:to).once
          @result = @input.send(:handle_event_received, { :message => @message })
        end

        should "return array of messages" do
          Scale.unstub(:transform)
          @result = @input.send(:handle_event_received, { :message => @message })
          assert_not_nil @result
          assert_equal Array, @result.class
          assert_not_empty @result

          @result.each do |message|
            assert_equal Message, message.class
            assert_equal :test_patch, message.namespace
            assert_not_nil message.index
            assert_not_nil message.value
          end
        end

        should "yield array of messages" do
          Scale.unstub(:transform)
          @input.send(:handle_event_received, { :message => @message }) do |hash|
            @result = hash
            assert_not_nil @result
            assert_equal Array, @result.class
            assert_not_empty @result

            @result.each do |message|
              assert_equal Message, message.class
              assert_equal :test_patch, message.namespace
              assert_not_nil message.index
              assert_not_nil message.value
            end
          end
        end

      end
    end
  end
end
