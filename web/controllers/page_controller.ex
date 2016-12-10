defmodule Sofa.PageController do
  use Sofa.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
