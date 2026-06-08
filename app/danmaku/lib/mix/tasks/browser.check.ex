defmodule Mix.Tasks.Browser.Check do
  use Mix.Task

  @moduledoc false
  @shortdoc "Run the browser smoke check"

  @impl true
  def run(_args) do
    if Mix.env() != :dev do
      Mix.raise("mix browser.check must be run with MIX_ENV=dev")
    end

    Mix.shell().info("Starting browser smoke check")

    script = "/usr/local/bin/browser-check.sh"

    case System.cmd("bash", [script], stderr_to_stdout: true) do
      {output, 0} ->
        Mix.shell().info(output)

      {output, status} ->
        Mix.raise("""
        Browser smoke check failed (exit status #{status}):

        #{output}
        """)
    end
  end
end
