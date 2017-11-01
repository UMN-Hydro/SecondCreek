# -*- coding: utf-8 -*-
"""
Created on Tue Oct 31 20:29:45 2017

@author: Jack
"""


import numpy as np
import pandas as pd
from matplotlib import pyplot as plt


PZCWelev =429.208

PZCCelev = 429.548


PZCCstickup = 154.94 #distance from PZCC TOC to streambed, cm
PZCWstickup = PZCCstickup - (PZCCelev - PZCWelev)

PZCClength = 182.88 #length of PZCC casing, cm
PZCWlength = 1.8288
dsCW = PZCWlength - PZCWstickup #distance from streambed to screened interval


dh1 =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff1_PZCWSG.csv', sep= ',', header = None ) #first half of summer
dh2= pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff2_PZCWSG.csv', sep= ',', header = None ) #second half of summer

#rename colums for ease of use

dh1.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh2.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)

#convert dates to datetime objects, set datess as dataframe index



dh1['date']= pd.to_datetime(dh1['date'], format= '%m/%d/%Y %H:%M')
dh1 = dh1.set_index(['date'])

dh2['date']= pd.to_datetime(dh2['date'], format= '%m/%d/%Y %H:%M')
dh2 = dh2.set_index(['date'])




#scale dh to .3 meters for 1dtemppro. Also make it negative to indicate higher head in the stream bed
dh1['deltah'] = dh1['deltah'] * -.3/dsCW
dh2['deltah'] = dh2['deltah'] *-.3/dsCW

#Save head data as a csv suitable for 1dtempProbePro. This requires reloading the
#csv as a numpy array so that the delimiter can be ', '. Pandas doesn't support multi
#character delimiters.
dh1.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1.csv',sep =',',date_format='%m/%d/%Y %H:%M', header = False)
dh2.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2.csv',sep =',',date_format='%m/%d/%Y %H:%M', header = False)
dh1temp = np.loadtxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1.csv', dtype =str , delimiter = ',')
dh2temp = np.loadtxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2.csv', dtype =str, delimiter = ',')
np.savetxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CW.csv',dh1temp,fmt= '%s', delimiter = ', ')
np.savetxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2CW.csv',dh2temp,fmt = '%s', delimiter = ', ')
#
#
#
#
#
#K1 = 4.0351
#K2 = 'NA'
#q = -1*dh1*K1/0.3
#plt.plot(q)
##plt.plot(dh2, color ='b')
#
#plt.xlabel('Date')
#plt.ylabel('q, m/d, positive is upwards ')
#plt.title('q TPB')
#plt.savefig("C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\TP_q_TS.png")
#q.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\TP_q_TS.csv', sep = ',', date_format='%m/%d/%Y %H:%M', header = False)
#plt.show()
#
##
#print np.mean(-1*dh1['deltah']*K1/0.3)