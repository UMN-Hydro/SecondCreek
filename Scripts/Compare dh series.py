#Plot dh time series so that they can be visually compared
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 01 10:44:46 2017

@author: Jack
"""



import numpy as np
import pandas as pd
from matplotlib import pyplot as plt


dhCC =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CC.csv', sep= ',', header = None ) #first half of summer
dhCW =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CW.csv', sep= ',', header = None ) #first half of summer
dhI =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1I.csv', sep= ',', header = None ) #first half of summer





dhCC.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dhCW.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dhI.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)


dhCC['date']= pd.to_datetime(dhCC['date'], format= '%m/%d/%Y %H:%M')
dhCC = dhCC.set_index(['date'])

dhCW['date']= pd.to_datetime(dhCW['date'], format= '%m/%d/%Y %H:%M')
dhCW = dhCW.set_index(['date'])

dhI['date']= pd.to_datetime(dhI['date'], format= '%m/%d/%Y %H:%M')
dhI = dhI.set_index(['date'])



plt.scatter(dhCC.index.values, dhCC['deltah']*.3, color = 'red')
plt.scatter(dhCW.index.values, dhCW['deltah']*.3, color = 'blue')
plt.scatter(dhI.index.values, dhI['deltah']*.3, color = 'green')
plt.xlim(min(dhCC.index.values),max(dhCC.index.values))
plt.ylim(-0.0001, 0.00)
plt.ylabel('dh/ds , negative up')
plt.title('red - PZCC, blue - PZCIW, green -PZI')
plt.show()



print 'CC average head'
print np.mean(dhCC['deltah']*.3) 

print 'CW average head'
print np.mean(dhCW['deltah']*.3) 


print 'PZI average head'
print np.mean(dhI['deltah']*.3) 

