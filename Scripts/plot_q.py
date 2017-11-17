# -*- coding: utf-8 -*-
"""
Created on Tue Nov 07 21:24:42 2017

@author: Jack


"""


import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

#inputs
fil ='C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\full summer CC.csv' #path to dh series used in 1dtemp
K  = 0.17065 #modeled from 1dtemp
q_avg = -0.018233 #avg q from 1dtemp


#read head timeseries
dh =pd.read_csv(fil, sep= ',', header = None ) #first half of summer, meters
dh.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh['date']= pd.to_datetime(dh['date'], format= '%m/%d/%Y %H:%M')

dh['deltah'] = dh['deltah'] /.3
dh['q'] = dh['deltah'] * -K

title ='q at TPB Whole Summer- modeled from PZCC data' #plot title

#plt.plot(dh['date'], dh['q'])
dh.q.plot()
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
plt.xlabel('Date')
plt.ylabel('q, m/d, positive is upwards ')
plt.title(title)
plt.savefig("C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\"+title)