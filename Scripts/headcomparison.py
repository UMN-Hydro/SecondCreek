# -*- coding: utf-8 -*-
"""
Created on Tue Feb 27 09:32:13 2018

@author: Jack



"""
import pandas as pd

path = 'C:\\SecondCreekGit\\DATA\\HEAD\\2016\\PROCESSED-not actually processed\\'


hCC = pd.read_csv(path+ 'pzcc_3_161005155030_M9438.csv', sep= ',', header = None )
hCW=pd.read_csv(path+'CW_processed.txt' , sep= ' ', header = None )
hI=pd.read_csv(path+ 'pzi_6_161005160841_M9505.csv', sep= ',', header = None )

hSG =pd.read_csv(path+ 'sg1_4_161005161403_H2366_FirstPlacement.csv', sep= ',', header = None ) #note this will require a shift


hI.rename(columns={0: 'date', 1: 'hI', 2:'temp'}, inplace = True)
hCC.rename(columns={0: 'date', 1: 'hCC', 2:'temp'}, inplace = True)

hCW.rename(columns={0: 'date', 1: 'hCW', 2:'temp'}, inplace = True)
hSG.rename(columns={0: 'date', 1: 'hSG', 2:'temp'}, inplace = True)


hI = hI.drop(['temp'], axis = 1)
hCC = hCC.drop(['temp'], axis = 1)

hCW = hCW.drop(['temp'], axis = 1)
hSG = hSG.drop(['temp'], axis = 1)


hCC['date']= pd.to_datetime(hCC['date'], format= '%Y/%m/%d %H:%M:%S')
hCC = hCC.set_index(['date'])

hCW['date']= pd.to_datetime(hCW['date'], format= '%Y/%m/%d %H:%M:%S')
hCW = hCW.set_index(['date'])

hI['date']= pd.to_datetime(hI['date'], format= '%Y/%m/%d %H:%M:%S')
hI = hI.set_index(['date'])

hSG['date']= pd.to_datetime(hSG['date'], format= '%Y/%m/%d %H:%M:%S')
hSG = hSG.set_index(['date'])

allh = pd.concat([hCC,hCW,hI,hSG], axis = 1, join = 'inner')

allh.plot()
