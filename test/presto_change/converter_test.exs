defmodule PrestoChange.ConverterTest do
  use ExUnit.Case

  alias PrestoChange.Converter
  alias PrestoChange.Snippets
  # doctest Converter

  test "has a PageState struct" do
    %Converter.PageState{}
  end

  test "sets input to indicated snippet" do
    ps = %Converter.PageState{}

    ps = ps |> Converter.set_snippet(:a)
    assert ps.input == Snippets.a

    ps = ps |> Converter.set_snippet(:ul)
    assert ps.input == Snippets.ul

    ps = ps |> Converter.set_snippet(:hello)
    assert ps.input == Snippets.hello

    ps = ps |> Converter.set_snippet(:bootstrap)
    assert ps.input == Snippets.bootstrap_navbar

    ps = ps |> Converter.set_snippet(:zurb)
    assert ps.input == Snippets.zurb_topbar
  end

  test "sets the output when the input is updated" do
    ps = %Converter.PageState{}

    ps = ps |> Converter.set_snippet(:a)
    assert ps.output == """
a(href: "") do
  "link text"
end
""" |> String.trim

    ps = ps |> Converter.set_snippet(:ul)
    assert ps.output == """
ul(class: "fruit") do
  li do
    "banana"
  end
  li do
    "apple"
  end
  li do
    "carrot"
  end
end
""" |> String.trim

    ps = ps |> Converter.set_snippet(:hello)
    assert ps.output == """
span(class: "welcome-message") do
  "Hello, World"
end
""" |> String.trim

    ps = ps |> Converter.set_snippet(:bootstrap)
    assert ps.output == """
nav(class: "navbar navbar-default") do
  div(class: "container-fluid") do
    html_comment(" Brand and toggle get grouped for better mobile display ")
    div(class: "navbar-header") do
      button(type: "button", class: "navbar-toggle collapsed", data-toggle: "collapse", data-target: "#bs-example-navbar-collapse-1", aria-expanded: "false") do
        span(class: "sr-only") do
          "Toggle navigation"
        end
        span(class: "icon-bar")
        span(class: "icon-bar")
        span(class: "icon-bar")
      end
      a(class: "navbar-brand", href: "#") do
        "Brand"
      end
    end
    html_comment(" Collect the nav links, forms, and other content for toggling ")
    div(class: "collapse navbar-collapse", id: "bs-example-navbar-collapse-1") do
      ul(class: "nav navbar-nav") do
        li(class: "active") do
          a(href: "#") do
            "Link "
            span(class: "sr-only") do
              "(current)"
            end
          end
        end
        li do
          a(href: "#") do
            "Link"
          end
        end
        li(class: "dropdown") do
          a(href: "#", class: "dropdown-toggle", data-toggle: "dropdown", role: "button", aria-haspopup: "true", aria-expanded: "false") do
            "Dropdown "
            span(class: "caret")
          end
          ul(class: "dropdown-menu") do
            li do
              a(href: "#") do
                "Action"
              end
            end
            li do
              a(href: "#") do
                "Another action"
              end
            end
            li do
              a(href: "#") do
                "Something else here"
              end
            end
            li(role: "separator", class: "divider")
            li do
              a(href: "#") do
                "Separated link"
              end
            end
            li(role: "separator", class: "divider")
            li do
              a(href: "#") do
                "One more separated link"
              end
            end
          end
        end
      end
      form(class: "navbar-form navbar-left", role: "search") do
        div(class: "form-group") do
          input(type: "text", class: "form-control", placeholder: "Search")
        end
        button(type: "submit", class: "btn btn-default") do
          "Submit"
        end
      end
      ul(class: "nav navbar-nav navbar-right") do
        li do
          a(href: "#") do
            "Link"
          end
        end
        li(class: "dropdown") do
          a(href: "#", class: "dropdown-toggle", data-toggle: "dropdown", role: "button", aria-haspopup: "true", aria-expanded: "false") do
            "Dropdown "
            span(class: "caret")
          end
          ul(class: "dropdown-menu") do
            li do
              a(href: "#") do
                "Action"
              end
            end
            li do
              a(href: "#") do
                "Another action"
              end
            end
            li do
              a(href: "#") do
                "Something else here"
              end
            end
            li(role: "separator", class: "divider")
            li do
              a(href: "#") do
                "Separated link"
              end
            end
          end
        end
      end
    end
    html_comment(" /.navbar-collapse ")
  end
  html_comment(" /.container-fluid ")
end
""" |> String.trim

    ps = ps |> Converter.set_snippet(:zurb)
    assert ps.output == """
div(class: "top-bar") do
  div(class: "top-bar-left") do
    ul(class: "dropdown menu", data-dropdown-menu: "data-dropdown-menu") do
      li(class: "menu-text") do
        "Site Title"
      end
      li(class: "has-submenu") do
        a(href: "#") do
          "One"
        end
        ul(class: "submenu menu vertical", data-submenu: "data-submenu") do
          li do
            a(href: "#") do
              "One"
            end
          end
          li do
            a(href: "#") do
              "Two"
            end
          end
          li do
            a(href: "#") do
              "Three"
            end
          end
        end
      end
      li do
        a(href: "#") do
          "Two"
        end
      end
      li do
        a(href: "#") do
          "Three"
        end
      end
    end
  end
  div(class: "top-bar-right") do
    ul(class: "menu") do
      li do
        input(type: "search", placeholder: "Search")
      end
      li do
        button(type: "button", class: "button") do
          "Search"
        end
      end
    end
  end
end
""" |> String.trim
  end
end
