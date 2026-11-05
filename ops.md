# ops

## build

```bash
make release
```

fzf 箭头选择 MV2 或 MV3，构建产物输出到 `_build/` 目录。

自动处理 nvm、npm install、git submodule 等前置依赖。

## MV2 vs MV3

| | MV2 | MV3 (Lite) |
|---|---|---|
| 过滤方式 | webRequest 实时拦截 | declarativeNetRequest 静态规则 |
| 动态过滤 | 有 | 无 |
| HTML 过滤 | 有 | 无 |
| 规则上限 | 无 | 30k/ruleset |
| 适用浏览器 | ungoogled-chromium, Firefox | Chrome, Edge |
| 产物路径 | `_build/mv2/uBlock0.chromium/` | `_build/mv3/uBOLite.chromium/` |

## load

- **Chromium 系**: `chrome://extensions/` → 开发者模式 → 加载已解压的扩展程序 → 选择产物目录
- **Firefox**: `about:debugging` → 临时载入附加组件 → 选择产物目录下 `manifest.json`
