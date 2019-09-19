defmodule Storex.Repo.Migrations.CreateAccountsUsers do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :email, :string
      add :name, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:accounts_users, :email)

  end
end
