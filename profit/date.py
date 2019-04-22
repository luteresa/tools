#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 18-11-27 下午4:25
# @Author  : Leon
# @Site    : 
# @File    : date.py
# @Software: PyCharm

from datetime import datetime

import matplotlib.pyplot as plt

import matplotlib.dates as mdates

dates= ['01/02/1991','01/03/1991','01/04/1991']
xs = [datetime.strptime(d,'%m/%d/%Y').date() for d in dates]
ys = range(len(xs))
print(xs)
print(ys)
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d/%Y'))
plt.gca().xaxis.set_major_locator(mdates.DayLocator())

plt.plot(xs,ys)
plt.gcf().autofmt_xdate()
plt.show()