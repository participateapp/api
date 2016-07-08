defmodule ParticipateApi.PostsRequestsSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint

  describe "index" do
    before do
      ex1 = %ParticipateApi.Example{title: "Example 1"} |> ParticipateApi.Repo.insert
      ex2 = %ParticipateApi.Example{title: "Example 2"} |> ParticipateApi.Repo.insert
      {:ok, ex1: ex1, ex2: ex2}
    end

    subject! do: get(conn(), examples_path(conn(), :index))

    it do: should be_successful
    it do: should be_success

    context "check body" do
      let :html, do: subject.resp_body

      it do: html |> should(have_content shared.ex1.title)
      it do: html |> should(have_text shared.ex2.title)
    end
  end
end
