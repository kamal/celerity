require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Link" do
  before :all do
    @ie = IE.new
    add_spec_checker(@ie)    
  end

  before :each do
    @ie.goto(TEST_HOST + "/non_control_elements.html")
  end
  
  # Exists method
  describe "#exist?" do
    it "should return true if the link exists" do
      @ie.link(:id, 'link_2').should exist
      @ie.link(:id, /link_2/).should exist
      @ie.link(:name, 'bad_attribute').should exist
      @ie.link(:name, /bad_attribute/).should exist
      @ie.link(:title, "link_title_2").should exist
      @ie.link(:title, /link_title_2/).should exist
      @ie.link(:text, "Link 2").should exist
      @ie.link(:text, /Link 2/i).should exist
      @ie.link(:url, 'non_control_elements.html').should exist
      @ie.link(:url, /non_control_elements.html/).should exist
      @ie.link(:index, 2).should exist
      @ie.link(:xpath, "//a[@id='link_2']").should exist
    end
    it "should return false if the link doesn't exist" do
      @ie.link(:id, 'no_such_id').should_not exist
      @ie.link(:id, /no_such_id/).should_not exist
      @ie.link(:name, 'no_such_name').should_not exist
      @ie.link(:name, /no_such_name/).should_not exist
      @ie.link(:title, "no_such_title").should_not exist
      @ie.link(:title, /no_such_title/).should_not exist
      @ie.link(:text, "no_such_text").should_not exist
      @ie.link(:text, /no_such_text/i).should_not exist
      @ie.link(:url, 'no_such_href').should_not exist
      @ie.link(:url, /no_such_href/).should_not exist
      @ie.link(:index, 1337).should_not exist
      @ie.link(:xpath, "//a[@id='no_such_id']").should_not exist
    end
    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @ie.link(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end
    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @ie.link(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end

  # Attribute methods
  describe "#class_name" do
    it "should return the type attribute if the link exists" do
      @ie.link(:index, 2).class_name.should == "external"
    end
    it "should return an empty string if the link exists and the attribute doesn't" do
      @ie.link(:index, 1).class_name.should == ''
    end
    it "should raise an UnknownObjectException if the link doesn't exist" do
      lambda { @ie.link(:index, 1337).class_name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#href" do
    it "should return the href attribute if the link exists" do
      @ie.link(:index, 2).href.should match(/non_control_elements/)
    end
    it "should return an empty string if the link exists and the attribute doesn't" do
      @ie.link(:index, 1).href.should == ""
    end
    it "should raise an UnknownObjectException if the link doesn't exist" do
      lambda { @ie.link(:index, 1337).href }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#url" do
    it "should return the href attribute" do
      @ie.link(:index, 2).url.should match(/non_control_elements/)
    end
  end
    
  describe "#id" do
    it "should return the id attribute if the link exists" do
      @ie.link(:index, 2).id.should == "link_2"
    end
    it "should return an empty string if the link exists and the attribute doesn't" do
      @ie.link(:index, 1).id.should == ""      
    end
    it "should raise an UnknownObjectException if the link doesn't exist" do
      lambda { @ie.link(:index, 1337).id }.should raise_error(UnknownObjectException)
    end
  end

  describe "#name" do
    it "should return the name attribute if the link exists" do
      @ie.link(:index, 3).name.should == "bad_attribute"
    end
    it "should return an empty string if the link exists and the attribute doesn't" do
      @ie.link(:index, 1).name.should == ''
    end
    it "should raise an UnknownObjectException if the link doesn't exist" do
      lambda { @ie.link(:index, 1337).name }.should raise_error(UnknownObjectException)
    end
  end
  
  describe "#text" do
    it "should return the link text" do
      @ie.link(:index, 2).text.should == "Link 2"
    end
    it "should return an empty string if the link exists and contains no text" do
      @ie.link(:index, 1).text.should == ""
    end
    it "should raise an UnknownObjectException if the link doesn't exist" do
      lambda { @ie.link(:index, 1337).text }.should raise_error(UnknownObjectException)
    end
  end

  describe "#title" do
    it "should return the type attribute if the link exists" do
      @ie.link(:index, 2).title.should == "link_title_2"
    end
    it "should return an empty string if the link exists and the attribute doesn't" do
      @ie.link(:index, 1).title.should == ""      
    end
    it "should raise an UnknownObjectException if the link doesn't exist" do
      lambda { @ie.link(:index, 1337).title }.should raise_error(UnknownObjectException)
    end
  end
  
  # Manipulation methods
  describe "#click" do
    it "should find an existing link by (:text, String) and click it" do
      @ie.link(:text, "Link 3").click
      @ie.text.include?("User administration").should be_true
    end
    it "should find an existing link by (:text, Regexp) and click it" do
      @ie.link(:url, /forms_with_input_elements/).click
      @ie.text.include?("User administration").should be_true
    end
    it "should find an existing link by (:index, Integer) and click it" do
      @ie.link(:index, 3).click
      @ie.text.include?("User administration").should be_true
    end
    it "should raise an UnknownObjectException if the link doesn't exist" do
      lambda { @ie.link(:index, 1337).click }.should raise_error(UnknownObjectException)
    end
  end

  after :all do
    @ie.close
  end

end
