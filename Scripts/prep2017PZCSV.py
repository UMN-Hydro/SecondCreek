# -*- coding: utf-8 -*-
"""
Created on Sun Nov 19 18:06:00 2017

@author: Jack
"""

import pandas as pd
import numpy as np
PZ = pd.DataFrame(columns =('date1','date2','pressure','temp'))
path = 'C:\\SecondCreekGit\\2017 Summer data dump\\Edited txt files\\MON_M3583\\1_171026105654_M3583'
#PZ =pd.read_csv('C:\\SecondCreekGit\\2017 Summer data dump\\Edited txt files\\MON_H2366\\pzpe_171026110611_H2366.txt', delimiter = "      ", header = None , engine = 'python') 
with open(path+'.txt') as f:
 
    for line in f:
#        cols =pd.DataFrame ( np.transpose(line.split()), columns =('date1','date2','pressure','temp'))
        cols =line.split()
        cols = pd.DataFrame([[cols[0], cols[1], cols[2], cols[3]]],  columns =('date1','date2','pressure','temp'))
        PZ = PZ.append(cols)
#PZ = pd.DataFrame([[PZ['date1'] +' '+ PZ['date2'] , PZ['pressure'], PZ['temp'] ]] , columns =('date','pressure','temp'))

PZ['date'] = PZ['date1'] +' '+ PZ['date2']
PZ = PZ[['date', 'pressure', 'temp'] ]

PZ['date']= pd.to_datetime(PZ['date'], format= '%Y/%m/%d %H:%M:%S')
PZ = PZ.set_index(['date'])

PZ.to_csv(path+'.csv',sep =',',date_format='%Y/%m/%d %H:%M:%S', header = False)
