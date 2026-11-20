#!/usr/bin/env bash
set -euo pipefail

mkdir -p .typst .fonts
archive="$(mktemp)"
trap 'rm -f "$archive"' EXIT

download() {
  curl --fail --silent --show-error --location --retry 3 --output "$2" "$1"
  if [[ -n "${3:-}" ]]; then
    printf '%s  %s\n' "$3" "$2" | sha256sum --check
  fi
}

download 'https://github.com/typst/typst/releases/download/v0.15.1/typst-x86_64-unknown-linux-musl.tar.xz' \
  "$archive" a6d077d0a95eed5a2eba715b2dae06be954f624ccbf85758a03f389ded33118c
tar -xJf "$archive" -C .typst --strip-components=1 typst-x86_64-unknown-linux-musl/typst

wenkai='https://github.com/lxgw/LxgwWenKai/releases/download/v1.521'
download "$wenkai/LXGWWenKai-Regular.ttf" .fonts/LXGWWenKai-Regular.ttf \
  b64b7add297672bf04c54ce229678ddf09b4f9671cb1ece1f24c868f4226edd0
download "$wenkai/LXGWWenKai-Medium.ttf" .fonts/LXGWWenKai-Medium.ttf \
  1b74667333612eb05b7a1a70a9b324458251cd81e9a1d6c1bfd22da871734b9c

noto='https://raw.githubusercontent.com/notofonts/noto-cjk'
download "$noto/523d033d6cb47f4a80c58a35753646f5c3608a78/Sans/Variable/TTF/Subset/NotoSansSC-VF.ttf" \
  .fonts/NotoSansSC-VF.ttf
download "$noto/9b0f1436e455d902de067a2501422e5dc71ad16b/Serif/OTF/SimplifiedChinese/NotoSerifCJKsc-Regular.otf" \
  .fonts/NotoSerifCJKsc-Regular.otf

fonts="$(.typst/typst fonts --ignore-system-fonts --font-path .fonts)"
for family in 'LXGW WenKai' 'Noto Sans SC' 'Noto Serif CJK SC'; do
  if ! grep -Fx "$family" <<< "$fonts"; then
    printf 'Typst could not find %s. Available fonts:\n%s\n' "$family" "$fonts" >&2
    exit 1
  fi
done
