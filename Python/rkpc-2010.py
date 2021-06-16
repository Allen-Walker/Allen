# 导入 bs4 库
from bs4 import BeautifulSoup
import re
import os
import requests

# 打印数组
def print_arr(arr_list):
  for item in arr_list:
    print(item)

def downloadhtml(url):
  response=requests.get(url)
  response.encoding="gb2312"
  print("\nr的类型"+str(type(response)))
  print("\n状态码是:"+str(response.status_code))
  print("\n头部信息:"+str(response.headers))
  print("\n响应内容:")
  print(response.text)
  # 保存文件。打开一个文件，w是文件不存在则新建一个文件，这里不用wb是因为不用保存成二进制
  file=open("./data-2010/urllist.html","w",encoding="utf-8")
  file.write(response.text)
  file.close()

def downloadxls(url, savefilename):
  download_url = url
  headers = {
    "User-Agent":"Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/80.0.3987.122Safari/537.36"
  }
  r = requests.post(url=download_url,headers=headers,stream=False)
  with open(savefilename,'wb') as f:
    if r.status_code==200: 
      # todo iter_content循环读取信息写入，chunk_size设置文件大小
      for chunk in r.iter_content(chunk_size=1):
        f.write(chunk)

def downloaddata(htmldir):
  # 创建 beautifulsoup 对象
  soup = BeautifulSoup(open(htmldir),features="lxml")
  xls_set = set()
  ### 建存放路径
  for anchor in soup.find_all('a'):
    url = anchor.get('href')
    if url != None:
      if re.search('.xls',url) != None:
        url = url.replace('\\','/')
        xlsfilename = anchor.string
        if url not in xls_set:
          xls_set.add(url)
          url = 'http://www.stats.gov.cn/tjsj/pcsj/rkpc/6rp/' + url
          savefilename = './data-2010/' + xlsfilename + '.xls'
          print(url)
          print(savefilename)
          # 下载xls文件
          downloadxls(url, savefilename)

if __name__ == '__main__':
#   下载html文件
  excellisturl = "http://www.stats.gov.cn/tjsj/pcsj/rkpc/6rp/lefte.htm"
  downloadhtml(excellisturl)
  downloaddata(r'./data-2010/urllist.html')
  
