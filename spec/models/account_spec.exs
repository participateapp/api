defmodule ParticipateApi.Models.AccountSpec do
  use ESpec.Phoenix, model: ParticipateApi.Account
  alias ParticipateApi.Account

  describe "#email" do
    it "is unique" do
      Repo.insert! %Account{email: "paulie@sopranos.tv", facebook_uid: "111"}
      changeset_for_dupe = Account.changeset(%Account{}, %{email: "paulie@sopranos.tv", facebook_uid: "222"})
      expect fn -> Repo.insert!(changeset_for_dupe) end  |> to(raise_exception)
    end
  end
end
