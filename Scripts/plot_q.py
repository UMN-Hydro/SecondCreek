#sloppy, quick and dirty script for plotting tsummer qts
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 07 21:24:42 2017

@author: Jack


"""


import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

#inputs
fil ='C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\PZI full summer.csv' #path to dh series used in 1dtemp
K  = 0.11022#modeled from 1dtemp
q_avg = -0.011204 #avg q from 1dtemp


#read head timeseries
dh =pd.read_csv(fil, sep= ',', header = None ) #first half of summer, meters
dh.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh['date']= pd.to_datetime(dh['date'], format= '%m/%d/%Y %H:%M')

dh['deltah'] = dh['deltah'] /.3
dh['q'] = dh['deltah'] * -K
dh = dh.drop('deltah', axis = 1)
title ='q at TPB Whole Summer- modeled from PZCC data' #plot title

plt.plot(dh['date'], dh['q'])

#dh.q.plot()
plt.axhline(-q_avg)
#plt.locator_params(numticks = 4)
#
#
#plt.figure()
#ax = fig.add_subplot(111)
#
#
#plt.plot(dh['date'],dh['q'])
#plt.plot(q_avg)
##plt.plot(dh2, color ='b')
#plt.xlabel('Date')
#plt.ylabel('q, m/d, positive is upwards ')
#plt.title(title)
#plt.savefig("C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\"+title)
dh.to_csv("TPC q TS.csv",sep =',',date_format='%m/%d/%Y %H:%M', header = False, index = False)