defmodule LibraryApiWeb.UserController do
  require Logger 

  use LibraryApiWeb, :controller
  alias LibraryApi.Library
  alias LibraryApi.Library.User
  alias LibraryApi.Library.Review


  plug :authenticate_user when action in [:show_current]

  def create(conn, %{"data" => data = %{ "type" => "users", "attributes" => _ }}) do
    data = JaSerializer.Params.to_attributes data

    case Library.create_user(data) do
      {:ok, %User{} = user } ->
        conn
        |> put_status(:created)
        |> render("show.json-api", data: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LibraryApiWeb.ErrorView, "400.json-api", changeset)
    end
  end

  def show_current(conn, %{current_user: user}) do
    conn
    |> render("show.json-api", data: user)
  end
end
