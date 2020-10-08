defmodule Mix.Tasks.Refresh do
  use Mix.Task
  require Logger

  @shortdoc "ds"

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

    # body = initial_request(lang)
    {downloaded_tags, total_count} =
      lang
      |> docker_url()
      |> fetch_tags(tags, with_count: true)

    if Enum.count(tags) == total_count do
      Logger.info("No new tags available for #{lang}")
      System.stop()
      Process.sleep(:infinity)
    end

    # first_page_tags = parse_tags(body)

    # fetch_tags(body["next"], tags, with_count: true)
    list =
      downloaded_tags
      # |> Enum.concat(first_page_tags)
      |> Enum.concat(tags)
      |> Enum.uniq()
      |> verify_count(total_count)
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
    body = dockerhub_request(url)

    downloaded_tags = parse_tags(body)
    last = List.last(downloaded_tags)
    url = body["next"]

    tags =
      if url && !Enum.member?(tags, last) do
        downloaded_tags ++ fetch_tags(url, tags, with_count: false)
      else
        downloaded_tags
      end

    if with_count do
      {tags, body["count"]}
    else
      tags
    end
  end

  defp parse_tags(body) do
    Enum.map(body["results"], & &1["name"])
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

  defp verify_count(tags, count) do
    tags_count = Enum.count(tags)

    if tags_count == count do
      tags
    else
      Logger.error(
        "Total count is #{count} and we downloaded #{tags_count}. Please run force refresh to fix this issue."
      )

      System.stop(1)
      Process.sleep(:infinity)
    end
  end
end
