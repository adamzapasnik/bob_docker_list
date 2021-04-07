defmodule BobDockerList.Sorter do
  # Elixir tags
  # 1.2.6-erlang-19.1.2-ubuntu-xenial-20200212
  # 1.2.6-erlang-19.0.3-debian-stretch-20200224
  # 1.2.6-erlang-19.3.6.9-ubuntu-xenial-20200326
  # 1.2.6-erlang-19.3.6.9-ubuntu-trusty-20191217
  # 1.2.6-erlang-19.3.6.9-debian-stretch-20200511
  # 1.2.6-erlang-19.3.6.9-ubuntu-bionic-20200403
  # 1.2.6-erlang-19.3.6.9-debian-jessie-20200511
  # 1.2.6-erlang-19.3.6.9-alpine-3.11.6
  # 1.2.6-erlang-19.3.6.9-alpine-3.12.0

  # Erlang tags
  # 23.1.1-ubuntu-focal-20200703
  # 23.1.1-ubuntu-bionic-20200630
  # 23.1.1-ubuntu-xenial-20200619
  # 23.1.1-ubuntu-trusty-20191217
  # 23.1.1-debian-buster-20200607
  # 23.1.1-debian-stretch-20200607
  # 23.1.1-debian-jessie-20200607
  # 23.1.1-alpine-3.12.0

  @erlang_tag_regex ~r"^(.+)-(alpine|ubuntu|debian)-([^-]+)-?(.*)$"
  @elixir_tag_regex ~r"^(.+)-erlang-(.+)-(alpine|ubuntu|debian)-([^-]+)-?(.*)$"

  def sorter(tag) do
    IO.inspect(tag)
    IO.inspect(tag =~ "erlang")

    if tag =~ "erlang" do
      [elixir_version, erlang_version, os, os_version, os_date] =
        Regex.run(@elixir_tag_regex, tag, capture: :all_but_first)

      {Version.parse!(elixir_version), erlang_version, os, os_sorter(os, os_version), os_date}
    else
      [erlang_version, os, os_version, os_date] = Regex.run(@erlang_tag_regex, tag, capture: :all_but_first)
      {erlang_version, os, os_sorter(os, os_version), os_date}
    end
  end

  defp os_sorter("ubuntu", version), do: ubuntu_sorter(version)
  defp os_sorter("debian", version), do: debian_sorter(version)
  defp os_sorter("alpine", version), do: version
  defp os_sorter(os, _), do: raise("Unknown OS #{os}, please add code to handle it")

  # debian
  defp debian_sorter("jessie"), do: 8
  defp debian_sorter("stretch"), do: 9
  defp debian_sorter("buster"), do: 10
  defp debian_sorter("bullseye"), do: 11
  defp debian_sorter("bookworm"), do: 12
  defp debian_sorter(version), do: raise("Unknown Debian version #{version}, please add code to handle it")

  # ubuntu
  defp ubuntu_sorter("trusty"), do: 14.04
  defp ubuntu_sorter("xenial"), do: 16.04
  defp ubuntu_sorter("bionic"), do: 18.04
  defp ubuntu_sorter("focal"), do: 20.04
  defp ubuntu_sorter("groovy"), do: 20.10
  defp ubuntu_sorter(version), do: raise("Unknown Ubuntu version #{version}, please add code to handle it")
end
