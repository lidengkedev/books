---
title: WebSocket
date: 2022-07-01 19:16:59
tags:
    - js
    - WebSocket
categories:
    - js
---

# WebSocket

WebSocket 是一种网络通信协议。RFC6455 定义了它的通信标准。
WebSocket 是 HTML5 开始提供的一种在单个 TCP 连接上进行全双工通讯的协议。

HTTP 协议是一种无状态的、无连接的、单向的应用层协议。它采用了请求/响应模型。通信请求只能由客户端发起，服务端对请求做出应答处理。
这种通信模型有一个弊端：HTTP 协议无法实现服务器主动向客户端发起消息。

WebSocket 连接允许客户端和服务器之间进行全双工通信，以便任一方都可以通过建立的连接将数据推送到另一端。WebSocket 只需要建立一次连接，就可以一直保持连接状态。

Web浏览器和服务器都必须实现 WebSockets 协议来建立和维护连接。由于 WebSockets 连接长期存在，与典型的HTTP连接不同，对服务器有重要的影响。
基于多线程或多进程的服务器无法适用于 WebSockets，因为它旨在打开连接，尽可能快地处理请求，然后关闭连接。任何实际的 WebSockets 服务器端实现都需要一个异步服务器。

var Socket = new WebSocket(url, [protocol] );
第一个参数 url, 指定连接的 URL。第二个参数 protocol 是可选的，指定了可接受的子协议。

> WebSocket 对象的属性

<table>
    <thead>
        <tr>
            <th>属性</th>
            <th>描述</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>readyState</td>
            <td>只读属性 readyState 表示连接状态，可以是以下值：0 - 表示连接尚未建立。1 - 表示连接已建立，可以进行通信。2 - 表示连接正在进行关闭。3 - 表示连接已经关闭或者连接不能打开。</td>
        </tr>
        <tr>
            <td>bufferedAmount</td>
            <td>只读属性 bufferedAmount 已被 send() 放入正在队列中等待传输，但是还没有发出的 UTF-8 文本字节数。</td>
        </tr>
    </tbody>
</table>

> WebSocket 对象的相关事件

<table>
    <thead>
        <tr>
            <th>事件</th>
            <th>事件处理程序</th>
            <th>描述</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>open</td>
            <td>Socket.onopen</td>
            <td>连接建立时触发</td>
        </tr>
        <tr>
            <td>message</td>
            <td>Socket.onmessage</td>
            <td>客户端接收服务端数据时触发</td>
        </tr>
        <tr>
            <td>error</td>
            <td>Socket.onerror</td>
            <td>通信发生错误时触发</td>
        </tr>
        <tr>
            <td>close</td>
            <td>Socket.onclose</td>
            <td>连接关闭时触发</td>
        </tr>
    </tbody>
</table>

> WebSocket 对象的相关方法

<table>
    <thead>
        <tr>
            <th>方法</th>
            <th>描述</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Socket.send()</td>
            <td>使用连接发送数据</td>
        </tr>
        <tr>
            <td>Socket.close()</td>
            <td>关闭连接</td>
        </tr>
    </tbody>
</table>

> 实例

```javascript
// 初始化一个 WebSocket 对象
var ws = new WebSocket("ws://localhost:9998/echo");

// 建立 web socket 连接成功触发事件
ws.onopen = function () {
    
    // 使用 send() 方法发送数据
    ws.send("发送数据");
    alert("数据发送中...");
};

// 接收服务端数据时触发事件 
ws.onmessage = function (evt) {
    
    var received_msg = evt.data; alert("数据已接收...");

};
// 断开 web socket 连接成功触发事件
ws.onclose = function () {

    alert("连接已关闭...");

};
```
