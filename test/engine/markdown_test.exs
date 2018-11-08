defmodule Breadcrumbs.MarkdownTest do
  @moduledoc false
  use ExUnit.Case

  alias Breadcrumbs.Markdown

  doctest Markdown

  test "h1 functionality" do
    assert Markdown.h1("a") == "\n# a\n\n"
    assert Markdown.h1(1) == "\n# 1\n\n"
  end

  test "h2 functionality" do
    assert Markdown.h2("a") == "\n## a\n\n"
    assert Markdown.h2(1) == "\n## 1\n\n"
  end

  test "h3 functionality" do
    assert Markdown.h3("a") == "\n### a\n\n"
    assert Markdown.h3(1) == "\n### 1\n\n"
  end

  test "h4 functionality" do
    assert Markdown.h4("a") == "\n#### a\n\n"
    assert Markdown.h4(1) == "\n#### 1\n\n"
  end

  test "h5 functionality" do
    assert Markdown.h5("a") == "\n##### a\n\n"
    assert Markdown.h5(1) == "\n##### 1\n\n"
  end

  test "linebreak functionality" do
    assert Markdown.linebreak() == "\n---\n\n"
  end

  test "unorderd list functionality" do
    assert Markdown.list("a") == "* a"
    assert Markdown.list(1) == "* 1"
  end

  test "quote functionality" do
    assert Markdown.quote_block("a") == "> a"
    assert Markdown.quote_block(1) == "> 1"
  end

  test "break functionality" do
    assert Markdown.break(1) == "<br>"
    assert Markdown.break(4) == "<br><br><br><br>"
  end

  test "link functionality" do
    assert Markdown.link("link") == "[link]"
  end

  test "inline link functionality" do
    assert Markdown.inline_link("text", "link") == "[text](link)"
  end
end
