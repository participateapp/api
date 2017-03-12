defmodule ParticipateApi.Models.SupportSpec do
  use ESpec.Phoenix, model: ParticipateApi.Support
  import ParticipateApi.Factory
  alias ParticipateApi.Repo
  alias ParticipateApi.Support

  describe "#proposal_id" do
    it "is required" do
      changeset = Support.changeset(%Support{}, %{author_id: 1})
      expect(changeset).to have_errors(proposal_id: {"can't be blank", []})
    end

    it "needs to match an existing proposal" do
      author = insert(:participant)
      changeset = Support.changeset(%Support{}, %{author_id: author.id, proposal_id: 1})
      {:error, changeset} = Repo.insert changeset
      expect(changeset).to have_errors(proposal: {"does not exist", []})
    end
  end
end
