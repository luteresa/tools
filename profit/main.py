#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 18-11-16 下午3:00
# @Author  : Leon
# @Site    : 
# @File    : main.py
# @Software: PyCharm
import trees
import treePlotter

def main():
    fr = open('lenses.txt')
    lenses = [inst.strip().split('\t') for inst in fr.readlines()]
    lensesLabels = ['age','prescript','astigmatic','tearRate']
    lensesTree = trees.createTree(lenses, lensesLabels)
    print(lensesTree)
    #treePlotter.createPlot(lensesTree)
    trees.storeTree(lensesTree,'lenses_Tree.txt')

if __name__ == '__main__':
    main()