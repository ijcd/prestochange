defmodule PrestoChangeWeb.PageView do
  use PrestoChangeWeb, :view

  def render("index.html", assigns) do
    Presto.Page.initial_page(:index, assigns[:visitor_id])
  end
end
