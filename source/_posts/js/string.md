---
title: String
date: 2022-07-01 19:16:06
tags:
    - js
    - String
categories:
    - js
---

# String

indexOf 无法识别 NaN , undefined

```javascript
[NaN].indexOf() == -1; // true
[undefined].indexOf() == -1; // true
```
