# Breadcrumbs

[![Hex pm](http://img.shields.io/hexpm/v/breadcrumbs.svg?style=flat)](https://hex.pm/packages/breadcrumbs)

[![GitHub license](https://img.shields.io/github/license/azohra/Breadcrumbs.svg)](https://github.com/azohra/Breadcrumbs/blob/master/LICENSE.md)

An elixir application that scrapes and renders release notes based on Jira tickets.

## Installation

The package can be installed by adding `breadcrumbs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:breadcrumbs, "~> 0.1.0"}
  ]
end
```

## Configuration

First, you will need to configure the url of your organizations Jira api endpoint:

```elixir
config :breadcrumbs, jira_api_url: "https://jira.example.com/rest/agile/{version}"
```

Second, you will need to configure the authorization header for your Jira api endpoint:

```Elixir
config :breadcrumbs, jira_api_auth: {"Authorization", "your_key_here"}
```

Finally, Breadcrumbs uses a pool of supervised workers to send your api requests concurrently.
By default there are 10 workers and each worker can only send one request at a time.
You can specify the number of workers like this:

```elixir
config :breadcrumbs, pool_size: 4
```

Altogether your configuration should look something like this

```elixir
config :breadcrumbs,
  jira_api_url: "https://jira.example.com/rest/agile/{version}",
  jira_api_auth: {"Authorization", "your_key_here"},
  pool_size: 4
```

## Usage

Breadcrumbs generates release notes using 2 distinct behaiviors: a formatter and a renderer. Renderers define arrangements
of tickets and formatters define how individual tickets are represented. This seperation is made because the structure of tickets and or
the fields contained within them often vary between projects. In order to keep modularity, you can reuse formatters to handle
different team's tickets, and use different renderers to get different styles of release notes.

---

Here is how to use Breadcrumbs


```elixir
  tickets = ["SAMPLE-001", "SAMPLE-002", ...]

  # Will use the built-in basic renderer and formatter
  Breadcrumbs.render(tickets)

  # Or enter the name of a custom module that implements the renderer behaivior
  Breadcrumbs.render(tickets, CustomRendererModuleName)
```

### Renderers

Renderers follow the [renderer](lib/breadcrumbs/schema/renderer_spec.ex) behaivior. They recieve a 
[%ScrapeData{}](lib/breadcrumbs/schema/scrape_data.ex) struct which contains a list of [%Ticket{}](lib/breadcrumbs/schema/ticket.ex)s
and a list of [%ErrorTicket{}](lib/breadcrumbs/schema/ticket.ex)s that indicate which tickets Breadcrumbs was unable to get.
The renderer then goes through tickets and uses a [formatter](lib/breadcrumbs/schema/formatter_spec.ex) to stringify each ticket. 
Renderers then arrange these stringified tickets into a complete release note. A renderer must return a string.

---

Overall, renderers just define the layout of the release note.

--- 

Here is Breadcrumbs' built-in renderer. If you design a custom renderer, your implementation of 
render/1 will define the structure of your release notes, while including or ommiting any data you choose.  

```elixir
  def render(tickets) do
    valid =
      tickets.valid
      |> Enum.map(fn ticket -> format(ticket) end)
      |> Enum.reduce("Release note:", fn ticket, message -> appendln(message, ticket) end)

    errors =
      tickets.errors
      |> Enum.map(fn ticket -> format(ticket) end)
      |> Enum.reduce("Errors:", fn ticket, message -> appendln(message, ticket) end)

    appendln(valid, errors)
  end
```

### Formatters

Formatters follow the [formatter](lib/breadcrumbs/schema/formatter_spec.ex) behaivior. They recieve a [%Ticket{}](lib/breadcrumbs/schema/ticket.ex) 
or an [%ErrorTicket{}](lib/breadcrumbs/schema/error_ticket.ex) and must return a string. Formatters are responsible for taking required fields 
and formatting them into a string. Some renderers may use multiple formatters if they want to format certain tickets in different 
ways.

---

Here is Breadcrumbs' built-in formatter.

```elixir
  def format(%Ticket{} = ticket) do
    "Ticket: #{ticket.key}"
  end

  def format(%ErrorTicket{} = error) do
    "Error in getting ticket: #{error.key}, Reason: #{error.reason}"
  end
```

## Examples

### Basic Renderer

```
Release Notes:
Closed: SAMPLE-001
Closed: SAMPLE-002
Errors:
Error in getting ticket: EP-780, Reason: not found
```

## Extending

Breadcrumbs includes a [markdown](lib/breadcrumbs/engine/markdown.ex) module as well as a [utilities](lib/breadcrumbs/engine/utils.ex)
module to aid in custom renderer / formatter implementations.