defmodule LibraryApiWeb.AuthorController do
  use LibraryApiWeb, :controller
  alias LibraryApi.Library
  alias LibraryApi.Library.Author

  plug :authenticate_user when action in [:create, :update, :delete]

  def index(conn, %{"filter" => %{"query" => search_term}}) do
    authors = Library.search_authors(search_term)
    render(conn, "index.json-api", data: authors)
  end

  def index(conn, _) do
    authors = Library.list_authors()
    render(conn, "index.json-api", data: authors)
  end

  def create(conn, %{:current_user => user, "data" => data = %{ "type" => "authors", "attributes" => _ }}) do
    data = data
    |> JaSerializer.Params.to_attributes()
    |> Map.put("user_id", user.id)

    case Library.create_author(data) do
      {:ok, %Author{} = author } ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", author_path(conn, :show, author))
        |> render("show.json-api", data: author)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(LibraryApiWeb.ErrorView, "400.json-api", changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    author = Library.get_author!(id)
    render(conn, "show.json-api", data: author)
  end

  def author_for_book(conn, %{"book_id" => book_id}) do
    author = Library.get_author_for_book(book_id)
    render(conn, "show.json-api", data: author)
  end

  def update(conn, %{"id" => id, "data" => data = %{ "type" => "authors", "attributes" => _ }}) do
    data = JaSerializer.Params.to_attributes data
    author = Library.get_author!(id)

    case Library.update_author(author, data) do
      {:ok, %Author{} = author} ->
        conn
        |> render("show.json-api", data: author)
      {:error, %Ecto.Changeset{} = changeset} -> 
        conn
        |> put_status(:unprocessable_entity)
        |> render(LibraryApiWeb.ErrorView, "400.json-api", changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Library.get_author!(id)
    with {:ok, %Author{} = author } <- Library.delete_author(author) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
