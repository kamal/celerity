require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Form" do
  before :all do
    @browser = Browser.new(:log_level => LOG_LEVEL)
  end

  before :each do
   @browser.goto(HTML_DIR + "/forms_with_input_elements.html")
  end

  describe "#exists" do
    it "returns true if the form exists" do
      @browser.form(:id, 'new_user').should exist
      @browser.form(:id, /new_user/).should exist
      @browser.form(:class, 'user').should exist
      @browser.form(:class, /user/).should exist
      @browser.form(:method, 'post').should exist
      @browser.form(:method, /post/).should exist
      @browser.form(:action, 'post_to_me').should exist
      @browser.form(:action, /to_me/).should exist
      @browser.form(:index, 1).should exist
      @browser.form(:xpath, "//form[@id='new_user']").should exist
    end

    it "returns true if the element exists (default how = :name)" do
      @browser.form("user_new").should exist
    end

    it "returns false if the form doesn't exist" do
      @browser.form(:id, 'no_such_id').should_not exist
      @browser.form(:id, /no_such_id/).should_not exist
      @browser.form(:class, 'no_such_class').should_not exist
      @browser.form(:class, /no_such_class/).should_not exist
      @browser.form(:method, 'no_such_method').should_not exist
      @browser.form(:method, /no_such_method/).should_not exist
      @browser.form(:action, 'no_such_action').should_not exist
      @browser.form(:action, /no_such_action/).should_not exist
      @browser.form(:index, 1337).should_not exist
      @browser.form(:xpath, "//form[@id='no_such_id']").should_not exist
    end

    it "raises TypeError when 'what' argument is invalid" do
      lambda { @browser.form(:id, 3.14).exists? }.should raise_error(TypeError)
    end

    it "raises MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.form(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end

  describe "#submit" do
    it "submits the form" do
      @browser.form(:id, "delete_user").submit
      @browser.text.should include("Semantic table")
    end
  end

end