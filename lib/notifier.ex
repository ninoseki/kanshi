defmodule Kanshi.Notifier do
  require Logger

  alias Kanshi.Configuration

  def notify(message) do
    Logger.info(message)

    if slack_webhook_url() != nil do
      case HTTPoison.post(slack_webhook_url(), payload(message), default_headers()) do
        {:ok, %HTTPoison.Response{status_code: 200, body: _body}} ->
          Logger.info(message)
          Logger.info("Notified.")

        {:ok, %HTTPoison.Response{status_code: _code, body: body}} ->
          Logger.error(body)

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error(reason)
      end
    end
  end

  @spec payload(String.t()) :: String.t()
  def payload(message) do
    Poison.encode!(%{
      channel: slack_channel_name(),
      text: message
    })
  end

  def default_headers do
    [{"Content-type", "application/json"}]
  end

  @spec slack_webhook_url() :: String.t() | nil
  def slack_webhook_url do
    Configuration.config()[:slack_webhook_url]
  end

  @spec slack_channel_name() :: String.t() | nil
  def slack_channel_name do
    Configuration.config()[:slack_channel_name]
  end
end
