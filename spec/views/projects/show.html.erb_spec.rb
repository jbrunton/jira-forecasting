require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :domain => "Domain",
      :rapid_board_id => 1,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Domain/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
  end
end
