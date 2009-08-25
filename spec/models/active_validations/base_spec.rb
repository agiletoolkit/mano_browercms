require File.dirname(__FILE__) + '/../../spec_helper'

class Model < ActiveValidations::Base
  attr_accessor :name, :quantity, :price
  validates_presence_of :name
  validates_numericality_of :quantity, :price
end

describe ActiveValidations::Base, "stubbing methods" do
  before(:each) do
    @model = Model.new(:name => "Some Name", :quantity => "123", :price => "12345")
  end
  
  it "should be valid" do
    @model.should be_valid
  end
  
  it "should have active record errors" do
    @model.errors.should be_kind_of(ActiveRecord::Errors)
  end
  
  it "should have save" do
    lambda{@model.save}.should_not raise_error
  end
  
  it "should have save!" do
    lambda{@model.save!}.should_not raise_error
  end
  
  it "should not be a new record" do
    @model.should_not be_new_record
  end
  
  it "should have update_attributes" do
    lambda{@model.update_attribute}.should_not raise_error
  end
  
  it "should have validates_presence_of" do
    @model.name = nil
    @model.should_not be_valid
  end
  
  it "should have validates_numericality_of for one attribute" do
    @model.quantity = "ABC"
    @model.should_not be_valid
  end
  
  it "should have validates_numericality_of for a second attribute" do
    @model.price = "ABC"
    @model.should_not be_valid
  end
  
  it "should still raise ordinary method missing errors" do
    lambda{@model.bad_method_name}.should raise_error(NoMethodError)
  end
end