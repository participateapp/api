defmodule ParticipateApi.Factory do
  use ExMachina.Ecto, repo: ParticipateApi.Repo

  def account_factory do
    %ParticipateApi.Account{
      email: sequence(:email, &"email-#{&1}@example.com"),
      facebook_uid: sequence("facebookuid"),
      participant: build(:participant)
    }
  end

  def participant_factory do
    %ParticipateApi.Participant{
      name: sequence("name"),
      account: build(:account)
    }
  end
end
