defmodule ParticipateApi.ExampleControllerSpec do
  use ESpec.Phoenix, controller: ParticipateApi.ExampleController

  describe "index" do
    let :examples do
      [
        %ParticipateApi.Example{title: "Example 1"},
        %ParticipateApi.Example{title: "Example 2"},
      ]
    end

    before do
      allow(ParticipateApi.Repo).to accept(:all, fn -> examples end)
    end

    subject do: action :index

    it do: should be_successful
    it do: should have_in_assigns(examples: examples)
  end
end
