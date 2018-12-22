defmodule LibraryApi.Library.Review do
  use Ecto.Schema
  import Ecto.Changeset
  alias LibraryApi.Library.Book
  alias LibraryApi.Library.User

  schema "reviews" do
    field :body, :string

    belongs_to :book, Book
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:user_id, :body, :book_id])
    |> validate_required([:user_id, :body, :book_id])
  end
end
