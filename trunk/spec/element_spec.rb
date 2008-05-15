require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Element" do

  before :all do
    @ie = IE.new
    add_spec_checker(@ie)
  end

  before :each do
    @ie.goto(TEST_HOST + "/forms_with_input_elements.html")
  end
  
  describe "#new" do
    it "should find elements matching the conditions when given a hash of :how => 'what' arguments" do
      @ie.checkbox(:name => 'new_user_interests', :title => 'Dancing is fun!').value.should == 'dancing'
      @ie.text_field(:class_name => 'name', :index => 2).id.should == 'new_user_last_name'
    end
    
    it "should raise UnknownObjectException with a sane error message when given a hash of :how => 'what' arguments" do
      conditions = {:index => 100, :name => "foo"}
      lambda { @ie.text_field(conditions).id }.should raise_error(UnknownObjectException, /Unable to locate object, using (\{:name=>"foo", :index=>100\}|\{:index=>100, :name=>"foo"\})/)
    end
  end
  
  describe "#method_missing" do
    it "should magically return the requested attribute if the attribute is defined in the attribute list" do
      @ie.form(:index, 1).action.should == 'post_to_me'
    end
    it "should raise NoMethodError if the requested method isn't among the attributes" do
      lambda { @ie.button(:index, 1).no_such_attribute_or_method }.should raise_error(NoMethodError)
    end
  end
  
  after :all do
    @ie.close
  end
end
