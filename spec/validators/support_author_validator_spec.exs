defmodule ParticipateApi.SupportAuthorValidatorSpec do
  use ESpec
  import ParticipateApi.Factory

  alias ParticipateApi.Support
  alias ParticipateApi.SupportAuthorValidator

  describe ".validate_no_previous_support_given_by_author" do
    let! :author, do: insert(:participant)
    let! :proposal, do: insert(:proposal)

    let :changeset do
      Support.changeset(%Support{}, %{author_id: author.id, proposal_id: proposal.id})
    end  

    subject do
      SupportAuthorValidator
        .validate_no_previous_support_given_by_author(changeset)
    end

    it "returns the changeset" do
      expect(subject).to eql changeset
    end

    it "doesn't add an error to the changeset" do
      expect(subject.errors).to eql []
    end

    context "when support was previously given" do
      let! :support, do: insert(:support, author: author, proposal: proposal)

      it "adds an error to changeset" do
        subject
        expect(changeset.errors).to eql [author: {"already supports this proposal", []}]
      end
    end
  end

  describe ".validate_supporter_not_author_of_proposal" do
    let! :author, do: insert(:participant)
    let! :proposal, do: insert(:proposal)

    let :changeset do
      Support.changeset(%Support{}, %{author_id: author.id, proposal_id: proposal.id})
    end  

    subject do
      SupportAuthorValidator
        .validate_supporter_not_author_of_proposal(changeset)
    end

    it "returns the changeset" do
      expect(subject).to eql changeset
    end

    it "doesn't add an error to the changeset" do
      expect(subject.errors).to eql []
    end

    context "when supporter is author of proposal" do
      let! :proposal, do: insert(:proposal, author: author)
      
      it "adds an error to changeset" do
        subject
        expect(changeset.errors).to eql [author: {"can't support own proposal", []}]
      end
    end
  end
end
