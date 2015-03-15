require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    assign(:project, Project.new(
      :domain => "MyString",
      :rapid_board_id => 1,
      :name => "MyString"
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input#project_domain[name=?]", "project[domain]"

      # assert_select "input#project_rapid_board_id[name=?]", "project[rapid_board_id]"

      # assert_select "input#project_name[name=?]", "project[name]"
    end
  end
end
