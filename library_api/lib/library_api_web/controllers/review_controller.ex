defmodule LibraryApiWeb.ReviewController do
  use LibraryApiWeb, :controller
  alias LibraryApi.Library
  alias LibraryApi.Library.Review

  plug :authenticate_user when action in [:create, :update]

  def index(conn, _) do
    reviews = Library.list_reviews
    render(conn, "index.json-api", data: reviews)
  end

  def reviews_for_book(conn, %{"book_id" => book_id}) do
    reviews = Library.list_reviews_for_book(book_id)
    render(conn, "index.json-api", data: reviews)
  end

  def create(conn, %{:current_user => user, "data" => data = %{ "type" => "reviews", "attributes" => _ }}) do

    data = data
    |> JaSerializer.Params.to_attributes
    |> Map.put("user_id", user.id)

    case Library.create_review(data) do
      {:ok, %Review{} = review} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", review_path(conn, :show, review))
        |> render("show.json-api", data: review)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LibraryApiWeb.ErrorView, "400.json-api", changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    review = Library.get_review!(id)
    render(conn, "show.json-api", data: review)
  end

  def update(conn, %{"id" => id, :current_user => user, "data" => data = %{ "type" => "reviews", "attributes" => _ }}) do
    review = Library.get_review!(id)
    data = data
    |> JaSerializer.Params.to_attributes
    |> Map.put("user_id", user.id)

    case Library.update_review(review, data) do
      {:ok, %Review{} = review} ->
        conn
        |> render("show.json-api", data: review)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LibraryApiWeb.ErrorView, "400.json-api", changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    review = Library.get_review!(id)
    with {:ok, %Review{}} <- Library.delete_review(review) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
