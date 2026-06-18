# 命令序列 —— 跟随 CFPS 数字鸿沟示例

在 Claude Code 中，于项目目录（`digital-divide-china-cfps/`）下，按以下顺序运行这些斜杠
命令。每条命令均摘自工作坊手册；章节编号指向手册，其中有完整演练与真实输出。

> English version: see `../en/COMMANDS.md`. 前置依赖与安装步骤见手册第一部分。

---

## 0. 先打开项目

```
$ cd ~/path/to/digital-divide-china-cfps   # 先进入项目目录
$ claude                                    # 然后在此启动 Claude Code
```

该目录下的每个会话都会自动读入 `CLAUDE.md`。

---

## 1. `scholar-init` —— 从安全开始（手册 §6）

创建标准项目目录树，对每个文件分级，并写入后续所有技能都会参考的安全契约。

```
> /scholar-init --slug digital-divide-china-cfps \
                --data ~/data/cfps/raw \
                --materials ~/data/cfps/materials
```

随后解决被标记为 `NEEDS_REVIEW` 的文件（在所有文件解决之前无法继续）：

```
> /scholar-init review
```

---

## 2. `scholar-brainstorm` —— 拓宽问题菜单（手册 §7）

MATERIALS 模式：指向码本，生成候选研究问题。

```
> /scholar-brainstorm materials top 5 RQs on digital divide in China,
                       CFPS 2010-2020, target Social Forces
```

---

## 3. `scholar-eda` —— 看数据（手册 §7-8 部分）

```
> /scholar-eda data/raw
```

仅产出 schema 级别的摘要（计数、分布），不打印受访者记录。

---

## 4. `scholar-idea` —— 把领域凝成具体谜题（手册 §8）

```
> /scholar-idea broad puzzle: "China's digital divide — access converging
  while use intensity persists by hukou, cohort, and gender"
  data: CFPS 2010-2020 long panel
  target: Social Forces
```

`idea/scholar-idea-digital-divide-china-cfps.md` 中已有一份参考种子构想——可与你的输出
对照。

---

## 5. `scholar-lit-review-hypothesis` —— 理论 + 假设（手册 §8A）

在 `scholar-idea` 之后运行。它替代分别运行 `scholar-lit-review` 与 `scholar-hypothesis`；
撰写理论框架与假设。

```
> /scholar-lit-review-hypothesis
```

---

## 6. `scholar-full-paper` —— 完整流水线（手册第三部分）

当构想值得写成一篇完整论文时，编排器逐阶段运行 设计 → EDA → 分析 → 验证 → 起草 → 评审
→ 复现包，每一道关卡都必须通过。

```
> /scholar-full-paper digital divide in China, CFPS 2010-2020,
  second-level (use-composition) divide by hukou / education / cohort,
  target Social Forces
```

恢复已停止的运行：

```
> /scholar-full-paper resume digital-divide-china-cfps
```

---

## 产物落点

技能产出的一切都在 `output/digital-divide-china-cfps/` 下：`design/`、`scripts/`、
`tables/`、`figures/`、`drafts/`、`verify/`、`citations/`、`replication-package/`、
`logs/`。详见项目 `README.md` 与手册 §4。

---

## 成本提示（手册 §3.5）

按任务切换模型：`scholar-eda`/监控/安装步骤用 `claude-haiku-4-5`，大部分分析与写作用
`claude-sonnet-4-6`，仅理论、识别备忘、事前剖析（pre-mortem）与最终对抗式评审用
`claude-opus-4-8` 配合 `/effort xhigh`。
