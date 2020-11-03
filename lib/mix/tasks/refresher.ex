defmodule Mix.Tasks.Refresh do
  use Mix.Task
  require Logger

  @shortdoc "Refresh list"

  def run(args) do
    Application.ensure_all_started(:hackney)

    {opts, [lang], []} = OptionParser.parse(args, strict: [force: :boolean])
    lang = String.downcase(lang)
    path = "#{lang}_list.txt"

    if opts[:force] && File.exists?(path) do
      File.rm(path)
    end

    tags =
      if File.exists?(path) do
        path
        |> File.read!()
        |> String.split("\n")
      else
        []
      end

    {downloaded_tags, total_count} =
      lang
      |> docker_url()
      |> fetch_tags(tags, with_count: true)

    downloaded_count = Enum.count(downloaded_tags)

    if downloaded_count != total_count do
      Logger.error(
        "Total count is #{total_count} and we downloaded #{downloaded_count}. Please run force refresh to fix this issue."
      )

      System.stop(1)
      Process.sleep(:infinity)
    end

    if downloaded_count == Enum.count(tags) do
      Logger.info("No new tags available for #{lang}")
      System.stop()
      Process.sleep(:infinity)
    end

    list =
      downloaded_tags
      |> Enum.concat(tags)
      |> Enum.uniq()
      |> Enum.sort_by(&BobDockerList.Sorter.sorter/1, :desc)
      |> Enum.join("\n")

    File.write(path, list)
  end

  def initial_request(lang) do
    lang
    |> docker_url()
    |> dockerhub_request()
  end

  defp fetch_tags(url, tags, with_count: with_count) do
    %{"next" => url, "count" => count, "results" => results} = dockerhub_request(url)

    downloaded_tags = Enum.map(results, & &1["name"])

    new_tags =
      tags
      |> Enum.concat(downloaded_tags)
      |> Enum.uniq()

    all_tags =
      if url && Enum.count(new_tags) != count do
        fetch_tags(url, new_tags, with_count: false)
      else
        new_tags
      end

    if with_count do
      {all_tags, count}
    else
      all_tags
    end
  end

  defp dockerhub_request(url) do
    Logger.info("Downloading #{url}")

    opts = [:with_body, recv_timeout: 10_000]
    {:ok, 200, _headers, body} = BobDockerList.HTTP.retry(fn -> :hackney.request(:get, url, [], "", opts) end)

    Jason.decode!(body)
  end

  defp docker_url(lang) do
    "https://hub.docker.com/v2/repositories/hexpm/#{lang}-amd64/tags?page_size=100"
  end
end
