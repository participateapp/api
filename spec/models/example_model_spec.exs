defmodule ParticipateApi.ExampleModelSpec do
  use ESpec.Phoenix, model: ParticipateApi.Example

  let :example, do: %ParticipateApi.Example{title: "Example 1"}
  it do: example.title |> should(eq "Example 1")
end
