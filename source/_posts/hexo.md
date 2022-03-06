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

## 文章
增加其他的文章只需要调用 Hexo 提供的命令即可:
```bash
$ hexo new hello-world
```
创建的文章会出现在 source/_posts 文件夹下，是 MarkDown 格式。

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

```
---
title: tags
date: 2022-03-06 22:24:59
---
```
我们可以自行添加一个 type 字段来指定页面的类型：

```
type: tags
comments:false 
```
然后再在主题的 _config.yml 文件将这个页面的链接添加到主菜单里面，修改 menu 字段如下：

```
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

```
type: categories
comments: false
```
然后再在主题的 _config.yml 文件将这个页面的链接添加到主菜单里面，修改 menu 字段如下：
```
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

```
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```
然后在主题的 _config.yml 里面修改如下：
```
local_search:
    enable: true
    top_n_per_article: 5
```
部署脚本
在根目录下新建一个 deploy.sh 的脚本文件，内容如下：
```bash
hexo clean

hexo generate

hexo deploy
```
这样我们在部署发布的时候只需要执行：
```bash
$ sh deploy.sh
```
就可以完成博客的更新了，非常简单。

