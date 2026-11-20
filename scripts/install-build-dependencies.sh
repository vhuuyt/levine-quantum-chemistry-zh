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

wenkai='https://github.com/lxgw/LxgwWenKai/releases/download/v1.530'
download "$wenkai/LXGWWenKai-Regular.ttf" .fonts/LXGWWenKai-Regular.ttf \
  2d73eea94ad808999d90c0000c239a84a33b09d4bc6ab6c5b8bbf1eda8a7fc8b
download "$wenkai/LXGWWenKai-Medium.ttf" .fonts/LXGWWenKai-Medium.ttf \
  f4b8a34d1f838fe411540cb7c97b1c384ac9738a876c4104500bc42508b2312a

noto='https://raw.githubusercontent.com/notofonts/noto-cjk'
download "$noto/523d033d6cb47f4a80c58a35753646f5c3608a78/Sans/Variable/TTF/Subset/NotoSansSC-VF.ttf" \
  .fonts/NotoSansSC-VF.ttf
download "$noto/9b0f1436e455d902de067a2501422e5dc71ad16b/Serif/OTF/SimplifiedChinese/NotoSerifCJKsc-Regular.otf" \
  .fonts/NotoSerifCJKsc-Regular.otf

fonts="$(.typst/typst fonts --ignore-system-fonts --font-path .fonts)"
for family in 'LXGW WenKai' 'Noto Sans SC' 'Noto Serif CJK SC'; do
  grep -Fx "$family" <<< "$fonts"
done
