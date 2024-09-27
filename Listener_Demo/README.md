# 简单介绍
## 实现
- 首先写一个监听器的类实现ServletRequestListener接口
- 其次在这个监听器类里面重写 requestInitialized 方法
- 在重写的方法里拿到request对象，并通过此对象的多种方法拿到请求的各种信息
- 将通过 System.currentTimeMillis() 方法拿到的时间转换格式，和其他信息一并打印在控制台上

## 测试
- 工程运行时默认跳转到测试的 Servlet，所以打开控制台，便可以看见关于请求的各种信息的日志