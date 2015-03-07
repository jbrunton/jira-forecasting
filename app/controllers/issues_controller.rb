class IssuesController < ApplicationController
  def index
    @issues = Issue.all
  end
  
  def sync
    @issues = Issue.all
    render "index"
  end
end
