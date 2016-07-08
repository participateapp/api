defmodule ParticipateApi.ExampleViewsSpec do
  use ESpec.Phoenix, view: ParticipateApi.ExamplesView

  describe "index html" do
    let :examples do
      [
        %ParticipateApi.Example{title: "Example 1"},
        %ParticipateApi.Example{title: "Example 2"},
      ]
    end

    subject do: render("index.html", examples: examples)

    it do: should have_content "Example 1"
    it do: should have_text "Example 2"
  end
end
