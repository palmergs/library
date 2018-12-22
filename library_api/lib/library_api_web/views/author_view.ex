defmodule LibraryApiWeb.AuthorView do
  use LibraryApiWeb, :view
  use JaSerializer.PhoenixView

  location "/authors/:id"

  attributes [:username, :first, :last]

  def attributes(author, conn) do
    author
    |> Map.put(:username, author.user.username)
    |> super(conn)
  end

  has_many :books,
    serializer: LibraryApiWeb.BookView,
    identifiers: :when_included,
    links: [
      related: "/authors/:id/books"
    ]

end
