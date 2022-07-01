---
title: 示例
date: 2022-07-01 19:01:15
tags:
    - example
categories:
    - example
---

# 示例

## 小例子

> js实现保存HTML到本地

```javascript
function fake_click(obj) {

    var ev = document.createEvent("MouseEvents");

    ev.initMouseEvent(
        "click", true, false, window, 0, 0, 0, 0, 0
        , false, false, false, false, 0, null
        );

    obj.dispatchEvent(ev);
}
 
function export_raw(name, data) {

   var urlObject = window.URL || window.webkitURL || window;
 
   var export_blob = new Blob([data]);
 
   var save_link = document.createElementNS("http://www.w3.org/1999/xhtml", "a")

   save_link.href = urlObject.createObjectURL(export_blob);

   save_link.download = name;

   fake_click(save_link);
}

var link = document.createElement('a');

link.innerText = '保存HTML到本地';

link.onclick = function () {

	export_raw('index.html', test);

}

link.clik();
```

