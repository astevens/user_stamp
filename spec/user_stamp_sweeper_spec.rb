require 'spec_helper'
describe UserStampSweeper, "#before_validation" do 
  before do
    comments_controller = mock(:current_user => 220)
    UserStamp.creator_attribute   = :creator
    UserStamp.updater_attribute   = :updater
    UserStamp.current_user_method = :current_user
    @sweeper = UserStampSweeper.instance
    @sweeper.stub!(:controller).and_return(comments_controller)
  end
  
  describe "(with new record)" do
    it "should set creator_id if attribute exists" do
      record = mock('Record', :creator= => nil, :updater= => nil, :new_record? => true, :changed? => true)
      record.should_receive(:creator=).with(220).once
      @sweeper.before_validation(record)
    end
    
    it "should NOT set creator_id if attribute does not exist" do
      record = mock('Record', :new_record? => true, :updater= => nil, :respond_to? => false)
      record.should_receive(:respond_to?).with("creator=").and_return(false)
      record.should_not_receive(:creator=)
      @sweeper.before_validation(record)
    end
  end
  
  describe "(with non new record)" do
    it "should NOT set creator_id if attribute exists" do
      record = mock('Record', :creator_= => nil, :updater= => nil, :new_record? => false, :changed? => true)
      record.should_not_receive(:creator=)
      @sweeper.before_validation(record)
    end
    
    it "should NOT set creator_id if attribute does not exist" do
      record = mock('Record', :updater= => nil, :new_record? => false, :changed? => true)
      record.should_not_receive(:creator=)
      @sweeper.before_validation(record)
    end
  end
  
  it "should set updater_id if attribute exists" do
    record = mock('Record', :creator= => nil, :updater= => nil, :new_record? => :false, :changed? => true)
    record.should_receive(:updater=)
    @sweeper.before_validation(record)
  end
  
  it "should NOT set updater_id if attribute does not exist" do
    record = mock('Record', :creator= => nil, :updater= => nil, :new_record? => :false, :respond_to? => false, :changed? => true)
    record.should_receive(:respond_to?).with("updater=").and_return(false)
    record.should_not_receive(:updater=)
    @sweeper.before_validation(record)
  end
end

describe UserStampSweeper, "#before_validation (with custom attribute names)" do
  before do
    comments_controller = mock(:current_user => 220)
    UserStamp.creator_attribute   = :created_by
    UserStamp.updater_attribute   = :updated_by
    UserStamp.current_user_method = :current_user
    @sweeper = UserStampSweeper.instance
    @sweeper.stub!(:controller).and_return(comments_controller)
  end
  
  describe "(with new record)" do
    it "should set created_by if attribute exists" do
      record = mock('Record', :created_by= => nil, :updated_by= => nil, :new_record? => true, :changed? => true)
      record.should_receive(:created_by=).with(220).once
      @sweeper.before_validation(record)
    end
    
    it "should NOT set created_by if attribute does not exist" do
      record = mock('Record', :new_record? => true, :updated_by= => nil, :respond_to? => false)
      record.should_receive(:respond_to?).with("created_by=").and_return(false)
      record.should_not_receive(:created_by=)
      @sweeper.before_validation(record)
    end
  end
  
  describe "(with non new record)" do
    it "should NOT set created_by if attribute exists" do
      record = mock('Record', :created_by= => nil, :updated_by= => nil, :new_record? => false, :changed? => true)
      record.should_not_receive(:created_by=)
      @sweeper.before_validation(record)
    end
    
    it "should NOT set created_by if attribute does not exist" do
      record = mock('Record', :updated_by= => nil, :new_record? => false, :changed? => true)
      record.should_not_receive(:created_by=)
      @sweeper.before_validation(record)
    end
  end
  
  it "should set updated_by if attribute exists" do
    record = mock('Record', :created_by= => nil, :updated_by= => nil, :new_record? => :false, :changed? => true)
    record.should_receive(:updated_by=)
    @sweeper.before_validation(record)
  end
  
  it "NOT set updated_by if record is unchanged" do
    record = mock('Record', :created_by= => nil, :updated_by= => nil, :new_record? => :false, :changed? => false)
    record.should_not_receive(:updated_by=)
    @sweeper.before_validation(record)
  end
  
  it "should NOT set updated_by if attribute does not exist" do
    record = mock('Record', :created_by= => nil, :updated_by= => nil, :new_record? => :false, :respond_to? => false, :changed? => true)
    record.should_receive(:respond_to?).with("updated_by=").and_return(false)
    record.should_not_receive(:updated_by=)
    @sweeper.before_validation(record)
  end
end

describe UserStampSweeper, "#current_user" do
  before do
    UserStamp.creator_attribute   = :creator_id
    UserStamp.updater_attribute   = :updater_id
    UserStamp.current_user_method = :current_user
    @sweeper = UserStampSweeper.instance
  end
  
  it "should send current_user if controller responds to it" do
    user = mock('User')
    controller = mock('Controller', :current_user => user)
    @sweeper.stub!(:controller).and_return(controller)
    controller.should_receive(:current_user)
    @sweeper.send(:current_user)
  end
  
  it "should not send current_user if controller does not respond to it" do
    user = mock('User')
    controller = mock('Controller', :respond_to? => false)
    @sweeper.stub!(:controller).and_return(controller)
    controller.should_not_receive(:current_user)
    @sweeper.send(:current_user)
  end
end

describe UserStampSweeper, "#current_user (with custom current_user_method)" do
  before do
    UserStamp.creator_attribute   = :creator_id
    UserStamp.updater_attribute   = :updater_id
    UserStamp.current_user_method = :my_user
    @sweeper = UserStampSweeper.instance
  end
  
  it "should send current_user if controller responds to it" do
    user = mock('User')
    controller = mock('Controller', :my_user => user)
    @sweeper.stub!(:controller).and_return(controller)
    controller.should_receive(:my_user)
    @sweeper.send(:current_user)
  end
  
  it "should not send current_user if controller does not respond to it" do
    user = mock('User')
    controller = mock('Controller', :respond_to? => false)
    @sweeper.stub!(:controller).and_return(controller)
    controller.should_not_receive(:my_user)
    @sweeper.send(:current_user)
  end
end
