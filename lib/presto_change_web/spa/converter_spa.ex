defmodule PrestoChangeWeb.ConverterSPA do
  alias PrestoChange.Snippets

  def button(id: "a") do
    %{"snippet" => Snippets.a}
  end

  def button(id: "ul") do
    %{"snippet" => Snippets.ul}
  end

  def button(id: "hello") do
    %{"snippet" => Snippets.hello}
  end

  def button(id: "bootstrap") do
    %{"snippet" => Snippets.bootstrap_navbar}
  end

  def button(id: "zurb") do
    %{"snippet" => Snippets.zurb_topbar}
  end

  def button(id) do
    %{"snippet" => inspect(id)}
  end
end
