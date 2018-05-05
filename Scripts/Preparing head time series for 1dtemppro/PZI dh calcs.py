#Script used to scale dh/dsd and get it into format for 1d temppro

# -*- coding: utf-8 -*-
"""
Created on Tue Oct 31 12:14:57 2017

@author: Jack
"""


import numpy as np
import pandas as pd
from matplotlib import pyplot as plt


PZIelev =429.098 #meters
PZCCelev = 429.548 #meters


PZCCstickup = 154.94 #distance from PZCC TOC to streambed, cm
PZIstickup = PZCCstickup - (PZCCelev - PZIelev)*100 #cm

PZIlength = 076.2 #cm
dsI = (PZIlength - PZIstickup)/100 #distance from streambed to screened interval in meters


    




#read in head difference timeseries. These time series were calculated from the PZdata dependent on the measured depths fro OCTOBER

dh1I =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff1_PZinSG.csv', sep= ',', header = None ) #first half of summer, meters
dh2I= pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff2_PZinSG.csv', sep= ',', header = None ) #second half of summer

#rename colums for ease of use

dh1I.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh2I.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)

#convert dates to datetime objects, set datess as dataframe index



dh1I['date']= pd.to_datetime(dh1I['date'], format= '%m/%d/%Y %H:%M')
dh1I = dh1I.set_index(['date'])

dh2I['date']= pd.to_datetime(dh2I['date'], format= '%m/%d/%Y %H:%M')
dh2I = dh2I.set_index(['date'])




#scale dh to .3 meters for 1dtemppro. dsI is negative, so multiplying by -1 is not necessary in this script
dh1I['deltah'] = dh1I['deltah'] * .3/dsI
dh2I['deltah'] = dh2I['deltah'] *.3/dsI 

#Save head data as a csv suitable for 1dtempProbePro. This requires reloading the
#csv as a numpy array so that the delimiter can be ', '. Pandas doesn't support multi
#character delimiters.

#Output  units are meters
dh1I.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1I.csv',sep =',',date_format='%m/%d/%Y %H:%M', header = False)
dh2I.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2I.csv',sep =',',date_format='%m/%d/%Y %H:%M', header = False)
dh1temp = np.loadtxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1I.csv', dtype =str , delimiter = ',')
dh2temp = np.loadtxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2I.csv', dtype =str, delimiter = ',')
np.savetxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1I.csv',dh1temp,fmt= '%s', delimiter = ', ')
np.savetxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2I.csv',dh2temp,fmt = '%s', delimiter = ', ')
#













#Garbage below






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
#plt.savefig("C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\TPA_q_TS.png")
#q.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\TPA_q_TS.csv', sep = ',', date_format='%m/%d/%Y %H:%M', header = False)
#plt.show()
#
##
#print np.mean(-1*dh1['deltah']*K1/0.3)