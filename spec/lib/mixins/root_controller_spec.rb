class TestRootController < UIViewController
  include RootController
end

class TestViewDeckController < IIViewDeckController
  def on_toggle(&block)
    @callback = block
  end
  def toggleLeftView
    @callback.call
  end
end

describe RootController do
  before do
    @test_controller = TestRootController.alloc.init
    @view_deck = TestViewDeckController.alloc.init
    @test_controller.viewDeckController = @view_deck
    self.controller = UINavigationController.alloc.initWithRootViewController(@test_controller)
  end
  
  tests TestRootController
  
  it "should show menu when menu is tapped" do
    toggled = false
    @view_deck.on_toggle do
      toggled = true
    end
    tap view('Menu')
    toggled.should == true
  end
end
