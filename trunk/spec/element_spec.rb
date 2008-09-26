require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Element" do

  before :all do
    @browser = Browser.new
  end

  before :each do
    @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
  end

  describe "::new" do
    it "should find elements matching the conditions when given a hash of :how => 'what' arguments" do
      @browser.checkbox(:name => 'new_user_interests', :title => 'Dancing is fun!').value.should == 'dancing'
      @browser.text_field(:class_name => 'name', :index => 2).id.should == 'new_user_last_name'
    end

    it "should raise UnknownObjectException with a sane error message when given a hash of :how => 'what' arguments (non-existing object)" do
      conditions = {:index => 100, :name => "foo"}
      lambda { @browser.text_field(conditions).id }.should raise_error(UnknownObjectException, /Unable to locate object, using (\{:name=>"foo", :index=>100\}|\{:index=>100, :name=>"foo"\})/)
    end

    it "should raise ArgumentError if given the wrong number of arguments" do
      container = mock("container", :null_object => true)
      lambda { Element.new(container, 1,2,3,4) }.should raise_error(ArgumentError, "wrong number of arguments (4 for 2)")
      lambda { Element.new(container, "foo") }.should raise_error(ArgumentError, "wrong number of arguments (1 for 2)")
    end
  end

  describe "#locate" do
    it "should raise ArgumentError when used with :object and the object given isn't an HtmlElement subclass" do
      lambda { Link.new(@browser, :object, "foo").locate }.should raise_error(ArgumentError, 'expected a HtmlUnit::Html::HtmlElement subclass, got "foo":String')
    end

  end

  describe "#focus" do
    it "should fire the onfocus event for the given element" do
      tf = @browser.text_field(:id, "new_user_occupation")
      tf.value.should == "Developer"
      tf.focus
      @browser.div(:id, "onfocus_test").text.should == "changed by onfocus event"
    end
  end

  describe "#parent" do
    it "should get the parent of this element" do
      @browser.text_field(:id, "new_user_email").parent.should be_instance_of(Form)
    end
  end

  describe "#visible?" do
    it "should return true if the element is visible" do
      @browser.text_field(:id, "new_user_email").should be_visible
    end

    it "should return false if the element is input element where type == 'hidden'" do
      @browser.text_field(:id, "new_user_interests_dolls").should_not be_visible
    end

    it "should return false if the element has style='display: none;'" do
      @browser.div(:id, 'changed_language').should_not be_visible
    end

    it "should return false if the element has style='visibility: hidden;" do
      @browser.div(:id, 'wants_newsletter').should_not be_visible
    end
    
    it "should return false if one of the parent elements is hidden" do
      @browser.div(:id, 'hidden_parent').should_not be_visible
    end
  end

  describe "#method_missing" do
    it "should magically return the requested attribute if the attribute is defined in the attribute list" do
      @browser.form(:index, 1).action.should == 'post_to_me'
    end

    it "should raise NoMethodError if the requested method isn't among the attributes" do
      lambda { @browser.button(:index, 1).no_such_attribute_or_method }.should raise_error(NoMethodError)
    end
  end

  describe "#html" do
    it "should return the descriptive (actual) html for the image element" do
      @browser.goto(TEST_HOST + "/images.html")
      @browser.image(:id, 'non_self_closing').html.chomp.should == '<img src="images/1.gif" alt="1" id="non_self_closing"></img>'
      @browser.goto(TEST_HOST + "/non_control_elements.html")
      @browser.div(:id, 'html_test').html.chomp.should ==
'<div id="html_test" class=some_class title = "This is a title">
    asdf
</div>' #TODO: This expected value might be a little off, whitespace-wise
    end
  end

  describe "#text" do
    it "should return a text representation including newlines" do
      @browser.goto(TEST_HOST + "/forms_with_input_elements.html")
      @browser.form(:id, "delete_user").text.should == "Username  Username 1 Username 2 Username 3 \nComment Default comment."
    end
  end

  after :all do
    @browser.close
  end
end
