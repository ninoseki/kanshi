defmodule Kanshi.Watcher do
  use WebSockex

  require Logger

  alias Kanshi.Configuration
  alias Kanshi.Notifier

  def start_link(opts \\ []) do
    validate_config()

    Logger.info("Initializing the watcher...")

    WebSockex.start_link(certstream_url(), __MODULE__, :fake_state, opts)
  end

  def handle_connect(_conn, state) do
    Logger.info("Connected.")
    {:ok, state}
  end

  def handle_frame({:text, message}, :fake_state) do
    json =
      message
      |> Poison.decode!()

    all_domains = extract_all_domains(json)

    case filter_domains(all_domains) do
      {:ok, _} -> Notifier.notify(extract_key_data_as_string(json))
      _ -> "no matching"
    end

    {:ok, :fake_state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect(reason)}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end

  def filter_domains(domains) do
    filtered =
      domains
      |> Enum.filter(fn x -> Regex.match?(regex_to_monitor(), x) end)

    if length(filtered) > 0 do
      {:ok, filtered}
    else
      {:error, "no matching results"}
    end
  end

  @spec extract_all_domains(map()) :: list(String.t())
  def(extract_all_domains(json)) do
    %{"data" => %{"leaf_cert" => %{"all_domains" => all_domains}}} = json
    all_domains
  end

  @spec extract_key_data_as_string(map()) :: String.t()
  def extract_key_data_as_string(json) do
    %{
      "data" => %{
        "cert_index" => cert_index,
        "seen" => seen,
        "source" => source,
        "leaf_cert" => %{"all_domains" => all_domains}
      }
    } = json

    data = %{
      "cert_index" => cert_index,
      "seen" => seen,
      "source" => source,
      "all_domains" => all_domains
    }

    Poison.encode!(data, pretty: true)
  end

  @spec certstream_url() :: String.t() | nil
  def certstream_url do
    Configuration.config()[:certstream_url]
  end

  @spec regex_to_monitor() :: Regex.t() | nil
  def regex_to_monitor do
    Configuration.config()[:regex_to_monitor]
  end

  def validate_config do
    if certstream_url() == nil do
      raise "Certstream server url is not configured. Please provide certstream_url via config."
    end

    if regex_to_monitor() == nil do
      raise "Regex for monitoring is not configured. Please provide regex_to_monitor via config."
    end
  end
end
