defmodule Kanshi.NotifierTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Kanshi.Configuration
  alias Kanshi.Notifier

  import ExUnit.CaptureLog

  setup do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
    slack_webhook_url = Configuration.config()[:slack_webhook_url]
    ExVCR.Config.filter_sensitive_data(slack_webhook_url, "YOUR_WEBHOOK_URL")
    :ok
  end

  test "#notify/1" do
    use_cassette "notify" do
      log =
        capture_log(fn ->
          Notifier.notify("test")
        end)

      assert log =~ "Notified"
    end
  end
end
