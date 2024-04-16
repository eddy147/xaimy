defmodule Xaimy.Repo do
  use Ecto.Repo,
    otp_app: :xaimy,
    adapter: Ecto.Adapters.Postgres
end
