defmodule Sofa.FileController do
  use Sofa.Web, :controller

  alias Sofa.File

  def index(conn, _params) do
    current_user_id = Coherence.current_user(conn).id
    user_files = Repo.all(from f in File, where: f.user_id == ^current_user_id)
    render(conn, "index.html", files: user_files)
  end

  def new(conn, _params) do
    changeset = File.changeset(%File{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"file" => file_params}) do
    # TODO: extract file data here
    updated_file_params = Map.put(file_params, "user_id", Coherence.current_user(conn).id)
    changeset = File.changeset(%File{}, updated_file_params)

    case Repo.insert(changeset) do
      {:ok, _file} ->
        conn
        |> put_flash(:info, "File created successfully.")
        |> redirect(to: file_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    file = Repo.get!(File, id)
    current_user_id = Coherence.current_user(conn).id
    IO.inspect file.user_id
    IO.inspect current_user_id
    case file.user_id do
      # i have no idea why this nil case is needed
      nil ->
        conn
        |> redirect(to: file_path(conn, :index))
      current_user_id ->
        IO.inspect "user match"
        render(conn, "show.html", file: file)
      _ ->
        conn
        |> redirect(to: file_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    file = Repo.get!(File, id)
    changeset = File.changeset(file)
    render(conn, "edit.html", file: file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Repo.get!(File, id)
    changeset = File.changeset(file, file_params)

    case Repo.update(changeset) do
      {:ok, file} ->
        conn
        |> put_flash(:info, "File updated successfully.")
        |> redirect(to: file_path(conn, :show, file))
      {:error, changeset} ->
        render(conn, "edit.html", file: file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Repo.get!(File, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(file)

    conn
    |> put_flash(:info, "File deleted successfully.")
    |> redirect(to: file_path(conn, :index))
  end
end
