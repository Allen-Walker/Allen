# -*- coding: utf-8 -*-

from urllib import request
import requests
from bs4 import BeautifulSoup
import re
import json

#  使用 urllib/request 发送请求

def func1():
    # url = 'http://www.baidu.com'
    url = 'http://www.dianping.com'
    res = request.urlopen(url)

    print(res.info()) # 响应头
    print(res.getcode()) # 状态码 2xx正常,3xx发生重定向,4xx访问资源问题,5xx服务器内部错误
    print(res.geturl()) # 返回响应地址

    #获取网页html源码
    html=res.read()
    print(html)

    #获取网页html源码
    html=res.read()
    # print(html)
    html=html.decode("utf-8") # 解决不显示中文问题
    print(html)

def func_2():
    # 简单解决网站反爬机制的问题
    # HTTPError: HTTP Error 403: Forbidden
    url="http://www.dianping.com"
    #最基本的反爬措施：添加header信息
    header={
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36"
    }
    req=request.Request(url,headers=header)
    res=request.urlopen(req)
    html=res.read()
    html=html.decode("utf-8")
    print(html)

# ConnectionResetError: [WinError 10054]
# 在request后面写入一个关闭的操作，
# response.close()
# 设置socket默认的等待时间，在read超时后能自动往下继续跑
# socket.setdefaulttimeout(t_default)
# 设置sleep()等待一段时间后继续下面的操作
# time.sleep(t)

#  使用 urllib/request 发送请求

def func_3():   
    url="http://www.baidu.com"
    res=requests.get(url)
    
    print(res.encoding)
    print(res.headers)
    # res.headers返回结果里面 如果没有Content-Type encoding=utf-8 否则 如果设置了charset就以设置的为准
    print(res.url) # 否则就是ISO-8859-1
    res.encoding="utf-8" # 前面已经看过了是ISO-8859-1，这里转一下否则显示乱码
    print(res.text)

def func_4():
    # url="http://www.dianping.com"
    # res=requests.get(url)
    
    # print(res.encoding)
    # print(res.headers)
    # print(res.url)
    # print(res.status_code)	# 查看状态码发现很不幸，又是403
    
    url="http://www.dianping.com"
    header={
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36"
    }
    res=requests.get(url,headers=header)
    
    print(res.encoding)
    print(res.headers)
    print(res.url)
    print(res.status_code)	# 此时的状态码是200说明可以正常访问了

# beautifulsoup4将复杂的HTML文档转换成一个树形结构，每个节点都是python对象。
# 安装：pip install beautifulsoup4
# BeautifulSoup(html)
# 获取节点：find()、find_all()/select()、
# 获取属性：attrs
# 获取文本：text

def func_5():
    # 四川卫健委官网的一个网页 http://wsjkw.sc.gov.cn/scwsjkw/gzbd/fyzt.shtml
    url="http://wsjkw.sc.gov.cn/scwsjkw/gzbd/fyzt.shtml"
    res=requests.get(url)
    res.encoding="utf-8"
    html=res.text
    soup=BeautifulSoup(html,features="lxml")
    a=soup.find("a") #获取网页a标签
    print(a)
    print(a.attrs) #打印标签属性
    print(a.attrs["href"]) #打印标签属性中的href的值
    
    # 获取该标签属性中的href值拼接新的url
    url_new="http://wsjkw.sc.gov.cn"+a.attrs["href"]
    print(url_new)
    res=requests.get(url_new)
    res.encoding="utf-8"
    soup=BeautifulSoup(res.text,features="lxml") #获取Html文本
    context=soup.find("p",features="lxml")
    print(context)
    
    # re解析内容
    pattern="新增(\d+)例确诊病例"
    res=re.search(pattern,context)
    print(res)

def func_6():
    import requests
    url="https://view.inews.qq.com/g2/getOnsInfo?name=disease_h5"
    #使用requests请求
    res=requests.get(url)
    # print(res.text) # 发现为json格式
    
    # 拿到json格式的数据后我们把它转换为字典
    d=json.loads(res.text)
    # print(d)
    print(d["data"])
    print(type(d["data"]))
    
    data_all=json.loads(d["data"])
    # 看下data的数据类型
    print(type(data_all))
    # 看下字典里面德数据有什么
    print(data_all.keys())
    
def func():
    strDataDir="../Data/getOnsInfo.json"
    f=open(strDataDir,encoding=('utf8'))
    text=f.read()
    d=json.loads(text)
    # print(d)
    # print(d["data"])
    print(type(d["data"]))
    data_all=json.loads(d["data"])
    
    print(len(data_all["areaTree"][0]["children"]))	#看看长度
    #写个循环遍历到省级
    for i in data_all["areaTree"][0]["children"]:
        print(i["name"]) #拿到各省名字
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
if __name__ == '__main__':
    func()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    