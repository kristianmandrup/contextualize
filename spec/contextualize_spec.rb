require 'spec_helper'

module ProjectViewer
  def view
    "view"
  end
end

module Admin
  module ProjectDetailedView
    def detailed_view
      "detailed_view"
    end
  end
end

module ProjectControl
  def control
    "control"
  end
end


class Project
  contextualize

  icontext :view, ProjectViewer, Admin::ProjectDetailedView
  icontext :control, ProjectControl
end


module EventView
  def view
    "view"
  end
end

module EventControl
  def control
    "control"
  end
end


class Event
  contextualize
  icontext  :control
  icontexts :view
end

describe "Contextualize" do
  let (:project) do
    Project.new
  end

  it "gracefully handles adding an invalid context to an object without raising error" do
    lambda {project.add_icontext :blip}.should_not raise_error
    lambda {project.remove_icontext :blip}.should_not raise_error
  end

  it "can add a context to an object" do
    project.add_icontext :view
    project.own_methods.should include(:view)

    project.view.should == "view"
    project.detailed_view.should == "detailed_view"
  end

  it "can remove a context from an object" do
    project.add_icontext :view  
    project.own_methods.should include(:view)

    project.remove_icontext :view
    lambda {project.view}.should raise_error
    lambda {project.detailed_view}.should raise_error
  end

  it 'can operate in a context scope' do
    project.icontext_scope :view, :control do |project|
      project.view.should == "view"
      project.control.should == "control"
    end
    lambda {project.view}.should raise_error
    lambda {project.control}.should raise_error
  end

  describe 'Array extension' do
    let (:events) do
      [Event.new, Event.new].add_icontext :view
    end

    it 'should work on an Array instance' do
      events.first.own_methods.should include(:view)
    end    
  end

  describe 'naming conventions' do
    let (:event) do
      Event.new
    end

    it 'should apply naming conventions' do
      event.add_icontext :view
      event.own_methods.should include(:view)
      event.view.should == "view"

      event.add_icontext :control
      event.own_methods.should include(:control)
    end
  end
end
