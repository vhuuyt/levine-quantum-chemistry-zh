# 《量子化学》第七版 · 中文翻译

原著为 Ira N. Levine 的 *Quantum Chemistry*, 7th edition。这里是个人中文翻译，仓库包含 Typst 排版源码及编译所需图件。

## 本地编译

安装 Typst 0.15.1，并安装霞鹜文楷（常规与中等字重）、Noto Sans SC 和 Noto Serif CJK SC。随后在仓库根目录运行：

```sh
typst compile book.typ levine-quantum-chemistry-zh.pdf
```

也可以把字体放在单独目录，通过 `typst compile --font-path <字体目录> book.typ levine-quantum-chemistry-zh.pdf` 指定。GitHub Actions 使用下方链接所列字体项目的固定版本。

- [霞鹜文楷](https://github.com/lxgw/LxgwWenKai/releases/tag/v1.521)
- [Noto CJK](https://github.com/notofonts/noto-cjk)

## GitHub Actions 和 Release

推送到 `main` 时，Actions 会编译并保存 PDF 构建产物。推送 `v*` 版本标签时，同一流程会将 CI 编译的 PDF 附到对应的 GitHub Release。

```sh
git tag -a v1.0.2 -m "中文翻译 v1.0.2"
git push origin v1.0.2
```
