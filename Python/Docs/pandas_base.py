# -*- coding: UTF-8 -*-

import pandas as pd

def panda_base():
  file_path = r'./test-xls.xls'
  # sheet_name不指定时默认返回全表数据
  df = pd.read_excel(file_path, sheet_name = "Sheet1")

  # 打印表数据，如果数据太多，会略去中间部分
  # print(df)

  # 打印头部数据，仅查看数据示例时常用
  print(df.head())

  # 打印列标题
  print(df.columns)

  # 打印行
  print(df.index)

  # 打印指定列
  # print(df["name"])

  # 描述数据
  print(df.describe())

  # 合并单元格
  # 使用fillna方法把缺失值重新编码为其他值，可以选择前置填充(fill forward)或后值填充(fill backward)，前值填充时，将按照前一个值填充缺失值。而按照后一个值填充则为后置填充
  print(df.fillna(method='ffill').iloc[0:4,0:8])

def pandas_merge():
  # https://bigdata.51cto.com/art/202007/620338.htm
  # https://blog.csdn.net/qq_17753903/article/details/89892631
  file_path = r'./test-xls.xls'
  df = pd.read_excel(file_path, sheet_name = "Sheet1")
  print(df.fillna(method='ffill').head())
  print(df.head())
  # print(df.fillna(method='pad').iloc[0:8,0:8])
  
  
 
if __name__ == "__main__":
  pandas_merge()
  print('---end---')
  
  
  

