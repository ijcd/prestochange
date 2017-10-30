defmodule PrestoChangeWeb.ConverterSPA do
  alias PrestoChange.Snippets

  def button(id: "a") do
    %{action: "snippet", data: Snippets.a}
  end

  def button(id: "ul") do
    %{action: "snippet", data: Snippets.ul}
  end

  def button(id: "hello") do
    %{action: "snippet", data: Snippets.hello}
  end

  def button(id: "bootstrap") do
    %{action: "snippet", data: Snippets.bootstrap_navbar}
  end

  def button(id: "zurb") do
    %{action: "snippet", data: Snippets.zurb_topbar}
  end

  def button(id) do
    %{action: "snippet", data: inspect(id)}
  end
end
