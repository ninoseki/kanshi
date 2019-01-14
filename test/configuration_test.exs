defmodule Kanshi.ConfigurationTest do
  use ExUnit.Case, async: true

  alias Kanshi.Configuration

  test "#config/1" do
    assert %{
             certstream_url: _,
             regex_to_monitor: _,
             slack_webhook_url: _,
             slack_channel_name: _
           } = Configuration.config()
  end
end
