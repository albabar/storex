defmodule Storex.AccountsTest do
  use Storex.DataCase

  alias Storex.Accounts

  describe "accounts_users" do
    alias Storex.Accounts.User

    @valid_attrs %{email: "john@doe.com", name: "John Doe", password: "some-password"}
#    @update_attrs %{email: "some updated email", name: "some updated name", password: "some-password"}
#    @invalid_attrs %{email: nil, name: nil, password_hash: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()
      user
    end

    test "create_user/1 creates a user with valid data" do
      assert {:ok, %User{}} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 does not save user with invalid data" do
      existing = user_fixture()
      {:error, changeset} = Accounts.create_user()

      assert "can't be blank" in errors_on(changeset).email
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).password

      {:error, changeset} = Accounts.create_user(%{password: "123"})
      assert "should be at least 6 character(s)" in errors_on(changeset).password

      invalid_attrs = %{@valid_attrs | email: existing.email}
      {:error, changeset} = Accounts.create_user(invalid_attrs)
      assert "has already been taken" in errors_on(changeset).email
    end

    test "get_user!/1 returns user if exists" do
      fixture = user_fixture()

      user = Accounts.get_user!(fixture.id)
      assert user.id == fixture.id
    end

    test "new_user/0 returns empty user changeset struct" do
      assert %Ecto.Changeset{} = Accounts.new_user()
    end

    test "authenticate_user/2 authenticate user based on email and password" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.authenticate_user(user.email, @valid_attrs.password)
    end

    test "authenticate_user/2 returns an error for invalid email" do
      assert {:error, "invalid user-identifier"} = Accounts.authenticate_user("invalid@email", @valid_attrs.password)
    end

    test "authenticate_user/2 returns an error for invalid password" do
      user = user_fixture()
      assert {:error, "invalid password"} = Accounts.authenticate_user(user.email, "invalid-password")
    end
  end
end
