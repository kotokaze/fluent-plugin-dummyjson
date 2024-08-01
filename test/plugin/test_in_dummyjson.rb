require "helper"
require "fluent/plugin/in_dummyjson.rb"

class DummyjsonInputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::DummyjsonInput).configure(conf)
  end
end
