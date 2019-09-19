defmodule Storex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts_users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> generate_password_hash
  end

  defp generate_password_hash(changeset=%{valid?: true}) do
    password = get_change(changeset, :password)
    change(changeset, Bcrypt.add_hash(password))
  end

  defp generate_password_hash(changeset), do: changeset

  def check_password(user, password) do
    Bcrypt.check_pass(user, password)
  end
end
