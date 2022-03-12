---
title: Echarts 3D 地图
date: 2022-03-06 22:25:59
tags:
categories:
---
@[toc]

# 利用echart和echart-gl绘制江苏省的地图之二

上一篇讲述了如何使用 `echarts@5.2.2` 和 `echarts-gl@2.0.8` 绘制江苏省的3D地图和绘制中存在的问题，而这篇文章将要讲述的是使用 `echarts@4.9.0` 和 `echarts-gl@1.0.1` 绘制江苏省的3D地图和绘制中存在的问题。
下面先看一下3D效果图：

![在这里插入图片描述](https://img-blog.csdnimg.cn/5ab7827298a04bfdaae62f1da1962155.gif#pic_center)

## 1 使用 echarts@4.9.0 和 echarts-gl@1.0.1 绘制江苏省地图
这里之所使用 `echarts@4.9.0` 和 `echarts-gl@1.0.1` 绘制江苏省的3D地图，原因是：

- `echarts` 高版本不支持更改`geo3D`中每个地级市的文本样式。
- `echarts` 高版本不支持 `geo3D` 中每个地级市区域的 `click` 事件。


### 1.1 这里采用 cdn 的方式全局引入

```html
<script src="https://cdn.jsdelivr.net/npm/echarts@4.9.0/dist/echarts.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/echarts-gl@1.0.1/dist/echarts-gl.min.js"></script>
```

当然你也可以使用

```bash
$ npm install echarts@4.9.0 echarts-gl@1.0.1
```

的方式安装后使用

```js
import * as echarts from 'echarts'
import 'echarts-gl'
```
的方式在模块中引入。

### 1.2 参数配置

这里的参数配置和 第一篇文章的配置如出一辙，不同的是，这次的配置中添加了环境贴图效果和地级市 `click`事件触发的效果。

#### 1.2.1 首先造一些地图上的假数据

```js
// 每个地级市地图上的值
const data = [
  { name: '南京市', value: 3802 },
  { name: '无锡市', value: 3802 },
  { name: '徐州市', value: 3412 },
  { name: '常州市', value: 3421 },
  { name: '苏州市', value: 3802 },
  { name: '南通市', value: 3432 },
  { name: '连云港市', value: 3512 },
  { name: '淮安市', value: 3802 },
  { name: '盐城市', value: 3802 },
  { name: '扬州市', value: 3802 },
  { name: '镇江市', value: 3802 },
  { name: '泰州市', value: 3612 },
  { name: '宿迁市', value: 3802 },
]
// 每个地级市的省会经纬度坐标
const gdGeoCoordMap = {
  "南京市": [118.767413,32.041544],
  "无锡市": [120.301663,31.574729],
  "徐州市": [117.184811,34.261792],
  "常州市": [119.946973,31.772752],
  "苏州市": [120.619585,31.299379],
  "南通市": [120.864608,32.016212],
  "连云港市": [119.178821,34.600018],
  "淮安市": [119.021265,33.597506],
  "盐城市": [120.139998,33.377631],
  "扬州市": [119.421003,32.393159],
  "镇江市": [119.452753,32.204402],
  "泰州市": [119.915176,32.484882],
  "宿迁市": [118.275162,33.963008],
}
// 将地级市的经纬度和具体的值结合处理成echarts可以接收的格式
const convertData = function(data) {
  var res = []
  for (var i = 0; i < data.length; i++) {
    var geoCoord = gdGeoCoordMap[data[i].name]
    if (geoCoord) {
      res.push({
        name: data[i].name,
        value: geoCoord.concat(data[i].value)
      })
    }
  }
  return res
}
```

#### 1.2.2 使用三维的地理坐标系组件绘制3D地图

```js
const geo3D = {
  map: '江苏',                   // 地图类型。
  boxDepth: 80,                 // 三维地理坐标系组件在三维场景中的深度
  regionHeight: 2,              // 三维地图每个区域的高度
  // 用于鼠标的旋转，缩放等视角控制
  viewControl: {
    autoRotate: false,          // 是否开启视角绕物体的自动旋转查看
    rotateSensitivity: 0,       // 旋转操作的灵敏度，值越大越灵敏。支持使用数组分别设置横向和纵向的旋转灵敏度。
    zoomSensitivity: 0,         // 缩放操作的灵敏度，值越大越灵敏。
    panSensitivity: 0,          // 平移操作的灵敏度，值越大越灵敏。支持使用数组分别设置横向和纵向的平移灵敏度
    alpha: 90,                  // 视角绕 x 轴，即上下旋转的角度。配合 beta 可以控制视角的方向。
    beta: 0,                    // 视角绕 y 轴，即左右旋转的角度。
    maxBeta: 45,                // 左右旋转的最大 beta 值。即视角能旋转到达最右的角度。
  },
  // 三维地理坐标系组件 中三维图形的视觉属性，包括颜色，透明度，描边等
  itemStyle: {
    opacity: 1,
    color: 'rgb(5,101,123)',  // 地图颜色
    borderWidth: 1,           // 分界线wdith
    borderColor: '#459bca',   // 分界线颜色
  },
  // 鼠标 hover 高亮时图形和标签的样式。
  emphasis: {
    label: {
      show: false,            // 是否显示高亮
    },
    itemStyle: {
      color: '#0489d6'        // 地图高亮颜色
    }
  },
  // 光照相关的设置。
  light: {
    // 场景主光源的设置
    main: {
      color: '#fff',          // 主光源的颜色
      intensity: 1.5,         // 主光源的强度
      shadow: true,           // 主光源是否投射阴影
      shadowQuality: 'high',  // 阴影的质量
      // alpha: 55,           // 主光源绕 x 轴，即上下旋转的角度
      // beta: 4,             // 主光源绕 y 轴，即左右旋转的角度
    },
    // 全局的环境光设置
    ambient: {
      color: '#fff',  // 环境光的颜色
      intensity: 2    // 环境光的强度
    },
    ambientCubemap: {
      diffuseIntensity: 2,  // 漫反射的强度
      specularIntensity: 2, // 高光反射的强度
    }
  },
}
```

#### 1.2.3 组合配置参数

```js
const options = {
  geo3D
}
```

### 1.3 绘制3D地图

#### 1.3.1 初始化画布

```js
// 初始化画布
const echart = echarts.init(document.getElementById('echarts'), {
  width: document.documentElement.clientWidth,
  height: document.documentElement.clientHeight
})

// 注册江苏省数据
echarts.registerMap('江苏', jiangsu)

// 绘制3D地图
echart.setOption(options)
```

#### 1.3.2 声明3D地图进入效果

首次进入，首先是一个平面图，紧接着反转 90 度，成一个有深度的3D地图

```js
function setMap3DBoxDepth(success) {
  let count = 90
  let timer = setInterval(() => {
    if (count <= 40) {
      clearInterval(timer)
      success()
    } else {
      count = count - 10
      echart.setOption({
        series: [{
          viewControl: {
            alpha: count
          }
        }]
      })
    }
  }, 30)
}
```

#### 1.3.3 处理地级市数据上的图片的位置

为什么要配置图片在地图上的位置呢？因为 echarts-gl 中无法设置 3D 的形状和彩色图片。这里使用生成 img 元素通过定位的方式在指定的位置放置图标。而此处的位置是采用鼠标的横纵坐标位置来设置的。

```js
function setImagesPosition(data = []) {
  data = [
    { name: '南京市', value: [628, 416, 1] },
    { name: '苏州市', value: [919, 485, 0] }
  ]
  for (let i = 0; i < data.length; i++) {
    const { value: [x,y,flag] } = data[i]
    const img = document.createElement('img')
    img.setAttribute('src', flag ? icon_01 : icon_02)
    img.setAttribute('style', `
      position: absolute;
      left: ${x}px;
      top: ${y}px;
      transform: translate(-50%, -50%) scale(0.6);
      pointer-events: none;
    `)
    document.getElementById('echarts').appendChild(img)
  }
}
```

#### 1.3.4 首次进入实现3D地图效果

```js
// 获取环境贴图的HTML元素
const mapBgImg = document.getElementById('map-bg')

// 平面转换为倾斜
setMap3DBoxDepth(() => {
  echart.setOption({
    series: [{
      shading: 'realistic',
      realisticMaterial: {
        // 材质细节的纹理贴图，参数只有三种格式：string、HTMLImageElement、HTMLCanvasElement
        detailTexture: mapBgImg
      },
      itemStyle: {
        borderColor: '#fff'
      }
    }]
  })
  setImagesPosition()
})
```

#### 1.3.5 点击地级市区域触发地图

```js
echart.on('click', (params) => {
  const { seriesType, name, event: { event: {x,y} } } = params
  console.log(['echart', name, x, y])
  if (seriesType === 'map3D' && name === '南京市') {
    console.log(name)
    this.is_show_dialog_city = true
    // 设置电厂的位置
    setFactoryPosition()
  }
})
```

### 1.4 设置南京市的地图

```html
<div id="dialog-box">
  <div class="dialog-close">&times;</div>
  <div id="dialog-warpper"></div>
</div>
```

#### 1.4.1 在南京是地图上设置具体的电厂的位置

```js
function setFactoryPosition(data = []) {
  data = [
    { x: 429, y: 92, name: '南京华润' },
    { x: 452, y: 288, name: '大唐南京' }
  ]
  for (let i = 0; i < data.length; i++) {
    const { x, y, name } = data[i]
    const box = document.createElement('div')
    const title = document.createElement('div')
    const img = document.createElement('img')

    box.setAttribute('class', 'factory-warpper')
    box.setAttribute('style', `
      left: ${x}px;
      top: ${y}px;
    `)

    title.setAttribute('class', 'factory-title')
    title.innerText = name

    img.setAttribute('src', icon_01)
    img.setAttribute('class', 'factory-icon')

    box.appendChild(title)
    box.appendChild(img)

    document.getElementById('dialog-warpper').appendChild(box)
  }
}
```

## 2. 存在的问题

1. `echarts@4.9.0` 和 `echarts-gl@1.0.1` 绘制3D无法设置3D图标。
2. 通过 鼠标的横纵坐标位置并使用 img 图片在3D地图上设置具体的图标的位置，非常的麻烦，需要计算画布的大小，和画布与img图标的相对位置。
3. 3D 地图边角不支持圆滑的边框效果。
4. 3D 环境贴图只有在最后一步设置，否则会失效，所以就出现了另一种问题，首次进入前3D地图没有贴图效果。

