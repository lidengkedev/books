---
title: Echarts 2D 地图
date: 2022-03-06 22:25:59
tags:
categories:
---

[TOC]

# 利用 echarts 绘制江苏省的地图之三

这篇文章是采用 ecahrts@5.2.2 通过绘制3层地图，来模拟实现3D的地图效果，在和真实的3D效果相比，还是有些差距的。

那么如何实现 3层 地图层叠效果呢？其实 echarts 已经提供了 `geo` 地理坐标系组件，这个组件可以传递一个数组用来放置多个地图，然后通过调整每个地图层的大小和位置以及层级关系，就可以轻松实现3层层叠的地图效果。

## 安装 与 引入

```bash
$ npm install echarts
```

```js
import * as from 'echarts' // echarts@5.2.2
```

## 基础配置

```js
const options = {
  geo: [
    map_01, // 底层地图
    map_02, // 中间层地图
    map_03  // 上层地图
  ],
  series: [
    series_01, // 波纹动效
    series_02, // 3d 图标
    series_03  // 展示信息
  ]
}
```

### 绘制3层江苏省的地图来模拟3D效果

首先来说明一下绘制地图需要用到的 `geo` 的属性说明：

- map: 使用 `registerMap` 注册的地图名称。
- z: 组件的所有图形的z值。控制图形的前后顺序。`z`值小的图形会被z值大的图形覆盖。
- layoutCenter: 定义地图中心在屏幕中的位置
- layoutSize: 地图的大小。支持相对于屏幕宽高的百分比或者绝对的像素大小。
- roam: 是否开启鼠标缩放和平移漫游。默认不开启。如果只想要开启缩放或者平移，可以设置成 `'scale'` 或者 `'move'`。设置成 `true` 为都开启。
- silent: 图形是否不响应和触发鼠标事件，默认为 `false`，即响应和触发鼠标事件。
- itemStyle: 地图区域的多边形 图形样式。
  - color: 图形的颜色。
  - borderWidth: 描边线宽。为 `0` 时无描边。
  - borderColor: 图形的描边颜色。支持的颜色格式同 `color`，不支持回调函数。
- emphasis: 高亮状态下的多边形和标签样式。
  - label: 地图上标签文本样式。
    - show: 是否显示标签。
  - itemStyle: 同 `itemStyle`。

然后再说明一下绘制地图数据`series`相关的动效和数据相关的属性：

- tooltip: 本系列特定的 `tooltip` 设定。
  - show: 是否显示提示框组件。
- type: 图形类型。
- coordinateSystem: 该系列使用的坐标系。`'cartesian2d'`: 使用二维的直角坐标系、`'polar'`: 使用极坐标系、`'geo'`: 使用地理坐标系。
- rippleEffect: 涟漪特效相关配置。
  - scale: 动画中波纹的最大缩放比例。
  - brushType: 波纹的绘制方式，可选 `'stroke'` 和 `'fill'`。
- showEffectOn: 配置何时显示特效。
- itemStyle: 图形样式。
  - color: 图形的颜色。 默认从全局调色盘 `option.color` 获取颜色。
- label: 图形上的文本标签，可用于说明图形的一些数据信息，比如值，名称等。
  - color: 文字的颜色。
  - formatter: 标签内容格式器，支持字符串模板和回调函数两种形式，字符串模板与回调函数返回的字符串均支持用 `\n` 换行。
- symbol: 标记的图形。
- symbolSize: 标记的大小，可以设置成诸如 `10` 这样单一的数字，也可以用数组分开表示宽和高，例如 `[20, 10]` 表示标记宽为`20`，高为`10`。
- symbolOffset: 标记相对于原本位置的偏移。
- data: 系列中的数据内容数组。数组项通常为具体的数据项。
- zlevel: 散点图所有图形的 `zlevel` 值。
- z: 散点图组件的所有图形的`z`值。控制图形的前后顺序。`z`值小的图形会被`z`值大的图形覆盖。`z`相比`zlevel`优先级更低，而且不会创建新的 `Canvas`。

#### 绘制最下面一层的地图

```js
const map_01 = {
  map: '江苏',
  z: 1,
  layoutCenter: ['49%', '51%'],
  layoutSize: '90%',
  roam: false,
  silent: true,
  itemStyle: {
    color: 'transparent',   // 地图的颜色
    borderWidth: 1,         // 分界线wdith
    borderColor: '#459bca', // 分界线颜色
  },
  emphasis: {
    label: {
      show: false
    },
    itemStyle: {
      color: 'transparent'
    }
  },
}
```

#### 绘制中间一层的地图

```js
const map_02 = {
  map: '江苏',
  z: 2,
  layoutCenter: ['49.5%', '50.5%'],
  layoutSize: '90%',
  roam: false,
  silent: true,
  itemStyle: {
    color: 'transparent',
    borderWidth: 1,
    borderColor: '#459bca',
  },
  emphasis: {
    label: {
      show: false
    },
    itemStyle: {
      color: 'transparent'
    }
  },
}
```

#### 绘制最上面的一层的地图，也是用来操作数据的一层地图

```js
const map_03 = {
  map: '江苏',
  z: 3,
  layoutCenter: ['50%', '50%'],
  layoutSize: '90%',
  show: true,
  roam: false,
  itemStyle: {
    color: 'rgb(5,101,123)',
    borderWidth: 0.5,
    borderColor: '#ffffff',
    borderJoin: 'round',
    borderCap: 'round',
  },
  label: {
    color: '#fff'
  },
  emphasis: {
    label: {
      color: '#fff'
    },
    itemStyle: {
      color: '#409EFF'
    }
  },
  regions: []
}
```

### 通过地级市的数据绘制3D图标

```js
const series_01 = {
  tooltip: {
    show: false,
  },
  type: 'effectScatter',
  coordinateSystem: 'geo',
  rippleEffect: {
    scale: 10,
    brushType: 'stroke',
  },
  showEffectOn: 'render',
  itemStyle: {
    normal: {
      color: '#00FFFF',
    }
  },
  label: {
    normal: {
      color: '#fff',
    },
  },
  symbol: 'circle',
  symbolSize: [10, 5],
  data: convertData(data),
  zlevel: 1,
}
```

### 通过地级市的数据绘制波纹动效

```js
const series_02 = {
  type: 'scatter',
  coordinateSystem: 'geo',
  itemStyle: {
    color: '#00FFF6',
  },
  symbol: 'image://' + icon_03,
  symbolSize: [32, 41],
  symbolOffset: [0, -20],
  z: 999,
  data: convertData(data),
}
```

### 通过地级市的数据绘制每个地级市的详细信息

```js
const series_03 = {
  type: 'scatter',
  coordinateSystem: 'geo',
  label: {
    normal: {
      show: true,
      formatter: function(params) { 
        var name = params.name
        var value = params.value[2]
        var text = `{fline|${value}人}\n{tline|${name}}`
        return text;
      },   
      color:'#fff',
      rich: {
        fline: {
          padding: [0, 25],
          color: '#fff',
          fontSize: 14,
          fontWeight:400
        },
        tline: {
          padding: [0, 27],
          color: '#ABF8FF',
          fontSize: 12,
        },
      }
    },
    emphasis: {
      show: true
    }
  },
  itemStyle: {
    color: '#00FFF6',
  },
  symbol: 'image://' + icon_04,
  symbolSize: [100, 50],
  symbolOffset: [0, -60],
  z: 999,
  data: convertData(data),
}
```
