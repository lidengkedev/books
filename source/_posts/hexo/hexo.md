---
title: Hexo
date: 2022-03-06 22:24:59
tags:
    - hexo
categories:
    - hexo
---

## 文章
增加其他的文章只需要调用 Hexo 提供的命令即可:

```bash
$ hexo new hello-world
```

创建的文章会出现在 `source/_posts` 文件夹下，是 `MarkDown` 格式。

在文章开头通过如下格式添加必要信息：
```
---
title: hexo
date: 2022-03-06 22:24:59
tags:
    - 标签1
    - 标签2
    - 标签3
categories:
    - 分类1
    - 分类2
---
```
开头下方撰写正文，MarkDown 格式书写即可。
这样在下次编译的时候就会自动识别标题、时间、类别等等，另外还有其他的一些参数设置，可以参考文档：https://hexo.io/zh-cn/docs/writing.html。

## 标签页
添加标签页：

```bash
$ hexo new page tags
```
执行这个命令之后会自动帮我们生成一个 source/tags/index.md 文件，内容就只有这样子的：

```yml
---
title: tags
date: 2022-03-06 22:24:59
---
```
我们可以自行添加一个 type 字段来指定页面的类型：

```yml
type: tags
comments: false 
```
然后再在主题的 _config.yml 文件将这个页面的链接添加到主菜单里面，修改 menu 字段如下：

```yml
menu:
    home: / || home
    tags: /tags/ || tags
    archives: /archives/ || archives
```

分类功能和标签类似，一个文章可以对应某个分类，如果要增加分类页面可以使用如下命令创建：

```bash
$ hexo new page categories
```

然后同样地，会生成一个 source/categories/index.md 文件。
我们可以自行添加一个 type 字段来指定页面的类型：

```yml
type: categories
comments: false
```
然后再在主题的 _config.yml 文件将这个页面的链接添加到主菜单里面，修改 menu 字段如下：

```yml
menu:
    categories: /categories/ || fa fa-th
```

## 搜索页
很多情况下我们需要搜索全站的内容，所以一个搜索功能的支持也是很有必要的。
如果要添加搜索的支持，需要先安装一个插件，叫做 hexo-generator-searchdb，命令如下：

```bash
$ npm install hexo-generator-searchdb --save
```

然后在项目的 _config.yml 里面添加搜索设置如下：

```yml
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```

然后在主题的 `_config.yml` 里面修改如下：

```yml
local_search:
    enable: true
    top_n_per_article: 5
```

### 站内引用文章

```
{% post_link 文章文件名（不要后缀） 文章标题（可选） %}
{% post_link hello-world %}
{% post_link hello-world hexo介绍 %}
```








## 部署脚本

在开始之前，您必须先在 _config.yml 中修改参数，一个正确的部署配置中至少要有 type 参数，例如：

```yml
deploy:
  type: git
```

您可同时使用多个 deployer，Hexo 会依照顺序执行每个 deployer。

```yml
deploy:
- type: git
  repo:
- type: heroku
  repo:
```

在根目录下新建一个 `deploy.sh` 的脚本文件，内容如下：

```bash
# 清空缓存文件
hexo clean
# 生成静态文件
hexo generate
# 部署静态资源文件
hexo deploy
```

这样我们在部署发布的时候只需要执行：

```bash
$ sh deploy.sh
```

就可以完成博客的更新了，非常简单。

> 缩进
YAML依靠缩进来确定元素间的从属关系。因此，请确保每个deployer的缩进长度相同，并且使用空格缩进。

### 第三方插件部署

安装 hexo-deployer-git

```bash
$ npm install hexo-deployer-git --save
```

修改配置

```yml
deploy:
  type: git
  repo: <repository url> #https://bitbucket.org/JohnSmith/johnsmith.bitbucket.io
  branch: [branch]
  message: [message]
```
|参数|	描述|	默认|
|---|---|---|
|`repo`|	库（Repository）地址|	|
|`branch`|	分支名称|	`gh-pages (GitHub)`、`coding-pages (Coding.net)`、`master (others)`|
|`message`|	自定义提交信息|	`Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }})`|
|`token`|	`Optional token value to authenticate with the repo. Prefix with $ to read token from environment variable`| | |

生成站点文件并推送至远程库。执行 `hexo clean && hexo deploy`。

登入 `Github/BitBucket/Gitlab`，请在库设置（`Repository Settings`）中将默认分支设置为`_config.yml`配置中的分支名称。稍等片刻，您的站点就会显示在您的`Github Pages`中。
