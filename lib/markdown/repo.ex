defmodule Markdown.Repo do
  use Ecto.Repo,
    otp_app: :markdown,
    adapter: Ecto.Adapters.Postgres
end
