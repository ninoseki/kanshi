defmodule Kanshi.WatcherTest do
  use ExUnit.Case

  alias Kanshi.Watcher

  test "#filter_domains/1" do
    {:ok, filtered_domains} = Watcher.filter_domains(["apple.com", "google.com"])

    assert filtered_domains == ["apple.com"]
  end

  test "#extract_all_domains/1" do
    json = %{
      "data" => %{
        "leaf_cert" => %{
          "all_domains" => [
            "e-zigarette-liquid-shop.de",
            "www.e-zigarette-liquid-shop.de"
          ]
        }
      }
    }

    all_domains = Watcher.extract_all_domains(json)

    assert all_domains == ["e-zigarette-liquid-shop.de", "www.e-zigarette-liquid-shop.de"]
  end

  test "#extract_key_items/1" do
    json = %{
      "data" => %{
        "leaf_cert" => %{
          "all_domains" => [
            "e-zigarette-liquid-shop.de",
            "www.e-zigarette-liquid-shop.de"
          ]
        },
        "cert_index" => 19_587_936,
        "seen" => 1_508_483_726.8601687,
        "source" => %{
          "url" => "mammoth.ct.comodo.com",
          "name" => "Comodo 'Mammoth' CT log"
        }
      }
    }

    key_data = Watcher.extract_key_data_as_string(json)

    assert key_data ==
             "{\n  \"source\": {\n    \"url\": \"mammoth.ct.comodo.com\",\n    \"name\": \"Comodo 'Mammoth' CT log\"\n  },\n  \"seen\": 1508483726.8601687,\n  \"cert_index\": 19587936,\n  \"all_domains\": [\n    \"e-zigarette-liquid-shop.de\",\n    \"www.e-zigarette-liquid-shop.de\"\n  ]\n}"
  end
end
