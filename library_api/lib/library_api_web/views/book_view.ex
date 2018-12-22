defmodule LibraryApiWeb.BookView do
  use LibraryApiWeb, :view
  use JaSerializer.PhoenixView

  location "/books/:id"

  attributes [:username, :title, :isbn, :publish_date]

  has_one :author,
    serializer: LibraryApiWeb.AuthorView,
    identifiers: :when_included,
    links: [
      related: "/books/:id/author"
    ]

  has_many :reviews,
    serializer: LibraryApiWeb.ReviewView,
    identifiers: :when_included,
    links: [
      related: "/books/:id/reviews"
    ]

  def attributes(model, conn) do
    model
    |> Map.put(:username, model.user.username)
    |> super(conn)
  end

end
