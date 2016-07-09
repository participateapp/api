defmodule ParticipateApi.AccountTest do
  use ParticipateApi.ModelCase

  alias ParticipateApi.Account

  @valid_attrs %{email: "some content", facebook_uid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
