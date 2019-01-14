# kanshi

[![Build Status](https://travis-ci.org/ninoseki/kanshi.svg?branch=master)](https://travis-ci.org/ninoseki/kanshi)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/kanshi/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/kanshi?branch=master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d074f4a65cb9421b941f9b69ae89d6d5)](https://www.codacy.com/app/ninoseki/kanshi)

Certificate Transparency (CT) logs monitoring with a regex.

## Description

kanshi monitors CT log stream via [CaliDog/certstream-server](https://github.com/CaliDog/certstream-server).

It outputs a notification if there is a certificate that has a Common Name which matches with a given regex.

## Prerequisite

- Elixir: `~> 1.7`

## Installation

```sh
git clone https://github.com/ninoseki/kanshi
cd kanshi
mix deps.get
```

## Configuration

Set a regex for monitoring as `regex_to_monitor` in `config/config.exs`.

```elixir
config :kanshi,
  certstream_url: "wss://certstream.calidog.io/",
  regex_to_monitor: ~r/your_regex/,
  slack_webhook_url: System.get_env("SLACK_WEBHOOK_URL"),
  slack_channel_name: System.get_env("SLACK_CHANNEL_NAME") || "general"
```

Also, if you want to receive a notification via Slack, set following environmental variables.

- SLACK_WEBHOOK_URL: A Slack webhook URL.
- SLACK_CHANNEL_NAME: A Slask channel name which will be notified.

## Usage

```sh
mix run --no-halt
```

Execution example with a regex(`~r/apple/`):

```sh
$ mix run --no-halt

04:59:06.463 [info]  Initializing the watcher...

04:59:08.655 [info]  Connected.

04:59:24.827 [info]  {
  "source": {
    "url": "ct.googleapis.com/skydiver/",
    "name": "Google 'Skydiver' log"
  },
  "seen": 1547495954.907261,
  "cert_index": 93463165,
  "all_domains": [
    "cpanel.greenapplesinvest.co.za",
    "greenapplesinvest.co.za",
    "mail.greenapplesinvest.co.za",
    "webdisk.greenapplesinvest.co.za",
    "webmail.greenapplesinvest.co.za",
    "www.greenapplesinvest.co.za"
  ]
}

04:59:25.289 [info]  {
  "source": {
    "url": "ct.googleapis.com/skydiver/",
    "name": "Google 'Skydiver' log"
  },
  "seen": 1547495954.907261,
  "cert_index": 93463165,
  "all_domains": [
    "cpanel.greenapplesinvest.co.za",
    "greenapplesinvest.co.za",
    "mail.greenapplesinvest.co.za",
    "webdisk.greenapplesinvest.co.za",
    "webmail.greenapplesinvest.co.za",
    "www.greenapplesinvest.co.za"
  ]
}

04:59:25.289 [info]  Notified.
```
