require 'spec_helper'

module ProjectView
  def view
    "view"
  end
end

module DetailedView
  def detailed_view
    "detailed_view"
  end
end

module ProjectControl
  def control
    "control"
  end
end



class Project
  contextualize

  icontext :view, ProjectView, DetailedView
  icontext :control, ProjectControl
end

module Contextualize
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
end

class Event
  contextualize

  icontexts :view, :control
end

describe "Contextualize" do
  let (:project) do
    Project.new
  end

  it "can add a context to an object" do
    project.add_icontext :view
    project.own_methods.should include('view')

    project.view.should == "view"
    project.detailed_view.should == "detailed_view"
  end

  it "can remove a context from an object" do
    project.add_icontext :view  
    project.own_methods.should include('view')

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

  describe 'naming conventions' do
    let (:event) do
      Event.new
    end

    it 'should apply naming conventions' do
      event.add_icontext :view
      event.own_methods.should include('view')

      event.view.should == "view"
    end
  end
end
