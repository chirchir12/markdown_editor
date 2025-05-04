defmodule MarkdownWeb.MarkdownEditLive do
  use MarkdownWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold mb-6">Markdown Editor</h1>

      <div class="flex flex-col md:flex-row gap-4">
        <!-- Left pane: Markdown input -->
        <div class="flex-1 border rounded-md">
          <div class="bg-gray-100 p-2 border-b">
            <h2 class="font-semibold">Markdown</h2>
          </div>
          <textarea
            phx-keyup="update-markdown"
            phx-debounce="300"
            class="w-full h-[500px] p-4 font-mono text-sm focus:outline-none"
            placeholder="Type your markdown here..."
          ><%= @markdown %></textarea>
        </div>
        
    <!-- Right pane: HTML preview -->
        <div class="flex-1 border rounded-md">
          <div class="bg-gray-100 p-2 border-b flex justify-between items-center">
            <h2 class="font-semibold">Preview</h2>
            <div class="flex gap-2">
              <button
                phx-click="copy-to-clipboard"
                id="copy-button"
                class="px-3 py-1 bg-blue-600 text-white text-sm rounded hover:bg-blue-700"
              >
                Copy
              </button>
              <button
                phx-click="export-pdf"
                class="px-3 py-1 bg-green-600 text-white text-sm rounded hover:bg-green-700"
              >
                Export
              </button>
            </div>
          </div>
          <div id="preview-content" class="markdown-body p-4 prose max-w-none h-[500px] overflow-auto">
            {raw(@html)}
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, markdown: example_markdown(), html: Earmark.as_html!(example_markdown()))}
  end

  @impl true
  def handle_event("update-markdown", %{"value" => markdown}, socket) do
    html =
      Earmark.as_html!(markdown, %Earmark.Options{
        code_class_prefix: "language-",
        smartypants: false
      })

    {:noreply, assign(socket, markdown: markdown, html: html)}
  end

  @impl true
  def handle_event("copy-to-clipboard", _params, socket) do
    {:noreply, push_event(socket, "copy_to_clipboard", %{})}
  end

  @impl true
  def handle_event("export-pdf", _params, socket) do
    filename = "markdown_export_#{DateTime.utc_now() |> DateTime.to_iso8601()}.pdf"
    {:noreply, push_event(socket, "export_pdf", %{filename: filename})}
  end

  defp example_markdown do
    """
    # Welcome to Markdown Editor

    This is a **real-time** markdown editor with _preview_.

    ## Features

    - Real-time markdown rendering
    - Export to PDF
    - Copy to clipboard

    ```elixir
    def hello do
      IO.puts("Hello, world!")
    end
    ```

    > This is a blockquote

    [Visit Phoenix Framework](https://www.phoenixframework.org/)
    """
  end
end
