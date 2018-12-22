defmodule LibraryApiWeb.SessionController do
  require Logger

  use LibraryApiWeb, :controller
  alias LibraryApi.Library

  def create(conn, %{"email" => email, "password" => password}) do

    Logger.info "In session create: #{ inspect(email) } => #{ inspect(password) }"
    try do
      user = Library.get_user_by_email!(email)

      Logger.info "User: #{ inspect(user) }"

      if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
        
        Logger.info "Passed bcrypt check!"

        conn
        |> render("token.json", user)
      else
      
        Logger.info "Failed bcrypt check!"

        conn
        |> put_status(:unauthorized)
        |> render(LibraryApiWeb.ErrorView, "401.json-api", %{detail: "Error logging in user"})
      end

    rescue 
      e ->

        Logger.error "Unable to process response? #{ inspect(e) }"

        Comeonin.Bcrypt.dummy_checkpw()

        conn
        |> put_status(:unauthorized)
        |> render(LibraryApiWeb.ErrorView, "401.json-api", %{detail: "Error logging in user"})
    end
  end
end
