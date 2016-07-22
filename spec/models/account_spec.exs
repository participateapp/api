defmodule ParticipateApi.Models.AccountSpec do
  use ESpec.Phoenix, model: ParticipateApi.Account
  alias ParticipateApi.Account

  describe "#email" do
    it "is required" do
      changeset = Account.changeset(%Account{}, %{facebook_uid: "111"})
      expect(changeset).to have_errors(email: {"can't be blank", []})
    end

    it "is unique" do
      Repo.insert! %Account{email: "paulie@sopranos.tv", facebook_uid: "111"}
      changeset_for_dupe = Account.changeset(%Account{}, %{email: "paulie@sopranos.tv", facebook_uid: "222"})
      expect fn -> Repo.insert!(changeset_for_dupe) end  |> to(raise_exception)
    end
  end

  describe "#facebook_uid" do
    it "is required" do
      changeset = Account.changeset(%Account{}, %{email: "paulie@sopranos.tv"})
      expect(changeset).to have_errors(facebook_uid: {"can't be blank", []})
    end
  end
end
