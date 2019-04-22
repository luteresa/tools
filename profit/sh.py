#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 18-11-28 下午5:00
# @Author  : Leon
# @Site    : 
# @File    : sh.py
# @Software: PyCharm

# shanghai
import tushare  as ts
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = ts.get_hist_data('hs300',start='2018-11-12',end='2018-11-28')
#print(type(df))
print(df)
#df.to_excel('hs.xlsx', startrow=2,startcol=5,columns=['close'])
#print(type(df['close']))
d=df.close.tolist()
print(type(d))
print(d)
d.reverse()
print(d)
exit()
sz=df.sort_index(axis=0, ascending=False) #对index进行升序排列
#print(df)
df.to_csv('hs300.csv',columns=['open','close'])

sz_return=sz[['p_change']] #选取涨跌幅数据
train=sz_return[0:255] #划分训练集
test=sz_return[255:]   #测试集
#对训练集与测试集分别做趋势图
plt.figure(figsize=(10,5))
train['p_change'].plot()
plt.legend(loc='best')
plt.show()
'''
plt.figure(figsize=(10,5))
test['p_change'].plot(c='r')
plt.legend(loc='best')
plt.show()
'''