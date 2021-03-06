require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Buttons" do

  before :all do
    @browser = Browser.new(:log_level => LOG_LEVEL)
  end

  before :each do
    @browser.goto(HTML_DIR + "/forms_with_input_elements.html")
  end

  describe "#length" do
    it "returns the number of buttons" do
      @browser.buttons.length.should == 8
    end
  end

  describe "#[]" do
    it "returns the button at the given index" do
      @browser.buttons[1].title.should == "Submit the form"
    end
  end

  describe "#each" do
    it "iterates through buttons correctly" do
      @browser.buttons.each_with_index do |b, index|
        b.name.should == @browser.button(:index, index+1).name
        b.id.should == @browser.button(:index, index+1).id
        b.value.should == @browser.button(:index, index+1).value
      end
    end
  end

  after :all do
    @browser.close
  end

end