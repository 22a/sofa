defmodule Sofa.FileController do
  use Sofa.Web, :controller

  alias Sofa.SFile

  def index(conn, _params) do
    current_user_id = Coherence.current_user(conn).id
    user_files = Repo.all(from f in SFile, where: f.user_id == ^current_user_id)
    render(conn, "index.html", files: user_files)
  end

  def new(conn, _params) do
    changeset = SFile.changeset(%SFile{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"s_file" => file_params}) do
    current_user_id = Coherence.current_user(conn).id
    %{"file" => f} = file_params
    file = %{"user_id" => current_user_id, "name" => f.filename}

    File.open!(f.path, [:read], fn(file) ->
      raw_file = IO.binread(file, :all)
    end)

    changeset = SFile.changeset(%SFile{}, file)

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
    file = Repo.get!(SFile, id)
    current_user_id = Coherence.current_user(conn).id

    case file.user_id do
      ^current_user_id ->
        render(conn, "show.html", file: file)
      _ ->
        conn
        |> redirect(to: file_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    file = Repo.get!(SFile, id)
    changeset = SFile.changeset(file)
    render(conn, "edit.html", file: file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "s_file" => file_params}) do
    file = Repo.get!(SFile, id)
    changeset = SFile.changeset(file, file_params)

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
    file = Repo.get!(SFile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(file)

    conn
    |> put_flash(:info, "File deleted successfully.")
    |> redirect(to: file_path(conn, :index))
  end
end
