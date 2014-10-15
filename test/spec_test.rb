require "helper"

class Patch::SpecTest < Test::Unit::TestCase

  context "Spec" do

    context ".new" do

      setup do
        @path = File.join(__dir__, "config/patches.yml")
        @file = File.new(@path)
        @hash = {
          :test => {
            :node_map => [{ [1,2] => 3 }],
            :action => []
          }
        }
      end

      context "path" do

        setup do
          @spec = Patch::Spec.new(@path)
        end

        should "populate" do
          assert_not_nil @spec
          assert_not_empty @spec
          assert_equal Hash, @spec.class
          assert_equal 1, @spec.keys.count
        end

      end

      context "file" do

        setup do
          @spec = Patch::Spec.new(@file)
        end

        should "populate" do
          assert_not_nil @spec
          assert_not_empty @spec
          assert_equal Hash, @spec.class
          assert_equal 1, @spec.keys.count
        end

      end

      context "hash" do

        setup do
          @spec = Patch::Spec.new(@hash)
        end

        should "populate" do
          assert_not_nil @spec
          assert_not_empty @spec
          assert_equal Hash, @spec.class
          assert_equal 1, @spec.keys.count
        end

      end

    end

  end
end