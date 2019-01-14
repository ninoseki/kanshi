defmodule Kanshi.Application do
  use Application

  def start(_type, _args) do
    children = [
      Kanshi.Configuration,
      {Kanshi.Watcher, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
