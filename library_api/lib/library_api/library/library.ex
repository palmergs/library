defmodule LibraryApi.Library do
  alias LibraryApi.Repo
  alias LibraryApi.Library.Author
  alias LibraryApi.Library.Book
  alias LibraryApi.Library.Review
  alias LibraryApi.Library.User
  import Ecto.Query

  def load_user({:ok, model}), do: {:ok, Repo.preload(model, :user)}
  def load_user({:error, model}), do: {:error, model}

  def list_authors, do: Repo.all(Author) |> Repo.preload(:user)
  def list_books, do: Repo.all(Book) |> Repo.preload(:user)

  def list_books_for_author(author_id) do
    Book
    |> where([b], b.author_id == ^author_id)
    |> Repo.all
    |> Repo.preload(:user)
  end
    
  def search_authors(search_term) do
    search_term = String.downcase(search_term)

    Author
    |> where([a], like(fragment("lower(?)", a.first), ^"%#{ search_term }%"))
    |> or_where([a], like(fragment("lower(?)", a.last), ^"%#{ search_term }%"))
    |> Repo.all
    |> Repo.preload(:user)
  end

  def search_books(search_term) do
    search_term = String.downcase(search_term)

    Book
    |> where([a], like(fragment("lower(?)", a.title), ^"%#{ search_term }%"))
    |> or_where([a], like(fragment("lower(?)", a.isbn), ^"%#{ search_term }%"))
    |> Repo.all
    |> Repo.preload(:user)
  end

  def get_author!(id), do: Repo.get!(Author, id) |> Repo.preload(:user)

  def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload(:user)

  def get_book_for_review(review_id) do
    review = get_review!(review_id)

    review = Repo.preload(review, :book)
    review.book
    |> Repo.preload(:user)
  end

  def get_author_for_book(book_id) do 
    book = get_book!(book_id)
    
    book = Repo.preload(book, :author)
    book.author
    |> Repo.preload(:user)
  end

  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert
    |> load_user
  end
  
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert
    |> load_user
  end

  def update_author(%Author{} = model, attrs \\ %{}) do
    model
    |> Author.changeset(attrs)
    |> Repo.update
    |> load_user
  end

  def update_book(%Book{} = model, attrs \\ %{}) do
    model
    |> Book.changeset(attrs)
    |> Repo.update
    |> load_user
  end
  
  def delete_author(%Author{} = model), do: Repo.delete(model)

  def delete_book(%Book{} = model), do: Repo.delete(model)

  def list_reviews do
    Repo.all(Review)
    |> Repo.preload(:user)
  end

  def list_reviews_for_book(book_id) do
    Review
    |> where([r], r.book_id == ^book_id)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_review!(id), do: Repo.get!(Review, id) |> Repo.preload(:user)

  def create_review(attrs \\ %{}) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
    |> load_user
  end

  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
    |> load_user
  end

  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email!(email), do: Repo.get_by!(User, email: email)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
