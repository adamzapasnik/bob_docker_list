defmodule BobDockerList.Sorter do
  def sorter(tag) do
    case String.split(tag, "-") do
      # alpine
      [erlang_version, os, os_version] ->
        {erlang_version, os, os_version, 0}

      [erlang_version, os, os_version, os_date] ->
        {erlang_version, os, os_sorter(os_version), os_date}

      # alpine
      [elixir_version, "erlang", erlang_version, os, os_version] ->
        {Version.parse!(elixir_version), erlang_version, os, os_version, 0}

      [elixir_version, "erlang", erlang_version, os, os_version, os_date] ->
        {Version.parse!(elixir_version), erlang_version, os, os_sorter(os_version), os_date}
    end
  end

  # debian
  defp os_sorter("jessie" <> ver), do: {8, ver}
  defp os_sorter("stretch" <> ver), do: {9, ver}
  defp os_sorter("buster" <> ver), do: {10, ver}
  defp os_sorter("bullseye" <> ver), do: {11, ver}
  defp os_sorter("bookworm" <> ver), do: {12, ver}

  # ubuntu
  defp os_sorter("trusty" <> ver), do: {14, ver}
  defp os_sorter("xenial" <> ver), do: {16, ver}
  defp os_sorter("bionic" <> ver), do: {18, ver}
  defp os_sorter("focal" <> ver), do: {20, ver}
end

# 1.2.6-erlang-19.1.2-ubuntu-xenial-20200212
# 1.2.6-erlang-19.0.3-debian-stretch-20200224
# 1.2.6-erlang-19.3.6.9-ubuntu-xenial-20200326
# 1.2.6-erlang-19.3.6.9-ubuntu-trusty-20191217
# 1.2.6-erlang-19.3.6.9-debian-stretch-20200511
# 1.2.6-erlang-19.3.6.9-ubuntu-bionic-20200403
# 1.2.6-erlang-19.3.6.9-debian-jessie-20200511
# 1.2.6-erlang-19.3.6.9-alpine-3.11.6
# 1.2.6-erlang-19.3.6.9-alpine-3.12.0

# 23.1.1-ubuntu-focal-20200703
# 23.1.1-ubuntu-bionic-20200630
# 23.1.1-ubuntu-xenial-20200619
# 23.1.1-ubuntu-trusty-20191217
# 23.1.1-debian-buster-20200607
# 23.1.1-debian-stretch-20200607
# 23.1.1-debian-jessie-20200607
# 23.1.1-alpine-3.12.0
