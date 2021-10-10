#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/newrelic/newrelic-cli"
TOOL_NAME="newrelic-cli"
TOOL_TEST="newrelic --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if newrelic-cli is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    awk -F/ '/tags/ && !/list/ {gsub("v",""); print $NF}'
}

list_all_versions() {
  # Change this function if newrelic-cli has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"
  platform=$(get_platform)
  arch=$(get_arch)
  ext=".tar.gz"
  case $platform in
    Darwin) arch="x86_64" ;;
    Windows) ext=".zip" ;;
  esac
  url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_${platform}_${arch}$ext"
  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path/bin"
    cp -R "$ASDF_DOWNLOAD_PATH/." "$install_path/bin"
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

get_arch() {
  local arch=""

  case "$(uname -m)" in
    x86_64 | amd64) arch="x86_64" ;;
    armv7l) arch="armv7" ;;
    aarch64 | arm64) arch="arm64" ;;
    *)
      fail "Arch '$(uname -m)' not supported!"
      ;;
  esac

  echo -n $arch
}

get_platform() {
  local platform=""

  case "$(uname | tr '[:upper:]' '[:lower:]')" in
    darwin) platform="Darwin" ;;
    linux) platform="Linux" ;;
    windows) platform="Windows" ;;
    *)
      fail "Platform '$(uname -m)' not supported!"
      ;;
  esac

  echo -n $platform
}
