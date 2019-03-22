defmodule Lfeview.Repo do
  use Ecto.Repo,
    otp_app: :lfeview,
    adapter: Ecto.Adapters.Postgres
end
