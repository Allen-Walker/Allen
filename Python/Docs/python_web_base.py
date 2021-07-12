import socket


def f1(request):
  return b'f1'

def f2(request):
  f = open('template.html','r',encoding='utf-8')
  data = f.read()
  f.close()
  import time
  ctime = time.time()
  data = data.replace('@@name@@',str(ctime))
  return bytes(data,encoding='utf-8')

routers=[
    ('/f1',f1),
    ('/f2',f2),
  ]

def run():
  sock = socket.socket()
  sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
  sock.bind(('127.0.0.1',8080))
  sock.listen(5)
  
  while True:
    conn,addr = sock.accept() # hang住
    # 有人来连接了
    # 获取用户发送的数据
    data = conn.recv(10000)
    data = str(data,encoding='utf-8')
    headers,bodys = data.split('\r\n\r\n')
    temp_list = headers.split('\r\n')
    method,url,protocal = temp_list[0].split(' ')
    conn.send(b"HTTP/1.1 200 OK\r\n\r\n")

    func_name = None
    for item in routers:
      if item[0] == url:
        func_name = item[1]
        break

    if func_name:
      response = func_name(data)
    else:  
      response = b"404"

    conn.send(response)
    conn.close()
    
if __name__ == '__main__':
  run()
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  