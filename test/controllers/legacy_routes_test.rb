require "test_helper"

class LegacyRoutesTest < ActiveSupport::TestCase
  test "does not recognize removed legacy routes" do
    [
      [ "/experiences", :get ],
      [ "/skills", :get ],
      [ "/softwares", :get ],
      [ "/languages", :get ]
    ].each do |path, method|
      assert_raises(ActionController::RoutingError) do
        Rails.application.routes.recognize_path(path, method:)
      end
    end
  end
end
