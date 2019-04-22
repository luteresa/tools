#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 18-11-26 下午3:58
# @Author  : Leon
# @Site    : 
# @File    : profit.py
# @Software: PyCharm

import numpy as np
import matplotlib.pyplot as plt
import xlrd
from datetime import datetime
import matplotlib.dates as mdates

import tushare  as ts
import pandas as pd


def create_figure(data):
    x_index = []
    hui_net_value = []
    fang_net_value = []
    hs_300 = []
    plt.figure(figsize=(8,6))
    for d in data:
        x_index.append(d[0])
        hui_net_value.append(d[1])
        fang_net_value.append(d[2])
        hs_300.append(d[3])

        plt.scatter(d[0],d[1],s=10,color='r')
        plt.scatter(d[0], d[2],s=10, color='b')
        plt.scatter(d[0], d[3], s=10, color='y')

        plt.annotate(str(round(d[1],3)), xy=(d[0], d[1]), xytext=(0, 0), textcoords='offset points', fontsize=12)
        plt.annotate(str(round(d[2],3)), xy=(d[0], d[2]), xytext=(0, 0), textcoords='offset points', fontsize=12)
        plt.annotate(str(round(d[3],3)), xy=(d[0], d[3]), xytext=(0, 0), textcoords='offset points', fontsize=12)

    plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y/%m/%d'))
    plt.gca().xaxis.set_major_locator(mdates.DayLocator())
    print(x_index)
    plt.gca().set_xlim(x_index[0], x_index[-1])
    #print(plt.xlim().date())
    L1, = plt.plot(x_index, hui_net_value, color='red', linewidth=1.0, linestyle='-')
    L2, = plt.plot(x_index, fang_net_value, color='blue', linewidth=1.0, linestyle='-')
    L3, = plt.plot(x_index, hs_300, color='y', linewidth=1.0, linestyle='-')

    plt.legend([L1, L2,L3], ['HUI', 'FANG','HS_300'], loc='upper right')
    plt.gcf().autofmt_xdate()
    #plt.gcf().figure(figsize=(1200,900))
    plt.savefig('he.jpg')
    #plt.show()
if __name__ == '__main__':
    #create_figure(data,index)
    file = xlrd.open_workbook('pk.xlsx')
    table = file.sheet_by_name('Sheet1')
    nrows = table.nrows
    ncols = table.ncols

    #tp = xlrd.xldate_as_tuple(table.cell(1,0).value,0)
    dt = xlrd.xldate_as_datetime(table.cell(1, 0).value, 0)
    #print(tp)
    print(dt)


    dateList = []
    dataList = []
    df_hs300 = ts.get_hist_data('hs300', start='2018-11-12', end='2018-11-29')
    # print(type(df))
    print(df_hs300)
    d_hs300 = df_hs300.close.tolist()
    #print(type(d_hs300))
    print(d_hs300)
    d_hs300.reverse()
    print('after:',d_hs300)
    for i in range(1,nrows):
        dateList.append(xlrd.xldate_as_datetime(table.cell(i, 0).value, 0).date())
        rows = table.row_values(i)
        dataList.append([rows[1],rows[2],d_hs300[i-1]])

    #print(dateList)
    #print(dataList)

    net_value = []
    base_value = dataList[0]
    print('base value:',base_value)


    for key,item in zip(dateList,dataList):
        print(key,item)
        net_value.append([key,item[0]/base_value[0],item[1]/base_value[1],item[2]/base_value[2]])
    #print("net value")
    for net in net_value:
        print(net)

    create_figure(net_value)
