
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

PZCCstickup = 154.94 #distance from PZCC TOC to streambed, cm
PZCClength = 182.88 #length of PZCC casing, cm
dsCC =( PZCClength - PZCCstickup )/100#distance from streambed to screened interval, meters

#PZCWstickup = 140.97 #distance from PZCW TOC to streambed, cm
#PZCWlength = 182.88 #length of PZCW casing, cm
#dsCW = PZCWlength - PZCWstickup #distance from streambed to screened interval
#
#
#
#PZCIstickup = 0.0 #distance from PZCC TOC to streambed, cm
#PZCIlength = 0.0 #length of PZCC casing, cm

#Script to take average q output from 1DTempProbePro and a deltaH time series to calculate average K. Additionally
#it scales the delta H data to 0.3 meters, (the distance between the top and bottom temperature probes) for future use with 1DTempPro.
#Script is useful for double checking the 1DTemp results. 
#Variable names ending in 1 indicate that they are from the begining of the summer, May-August 1
#Variables names ending in 2 indicate that they are the end of summer, aug 1 - october
    




#read in head difference timeseries. These time series were calculated from the PZdata dependent on the measured depths fro OCTOBER

dh1CC =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff1_PZCCSG.csv', sep= ',', header = None ) #first half of summer, meterse
dh2CC = pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff2_PZCCSG.csv', sep= ',', header = None ) #second half of summer

#rename colums for ease of use

dh1CC.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh2CC.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)

#convert dates to datetime objects, set datess as dataframe index



dh1CC['date']= pd.to_datetime(dh1CC['date'], format= '%m/%d/%Y %H:%M')
dh1CC = dh1CC.set_index(['date'])

dh2CC['date']= pd.to_datetime(dh2CC['date'], format= '%m/%d/%Y %H:%M')
dh2CC = dh2CC.set_index(['date'])




#scale dh to .3 meters for 1dtemppro. Also make it negative to indicate higher head in the stream bed
dh1CC['deltah'] = dh1CC['deltah'] * -.3/dsCC
dh2CC['deltah'] = dh2CC['deltah'] *- .3/dsCC 

#Save head data as a csv suitable for 1dtempProbePro. This requires reloading the
#csv as a numpy array so that the delimiter can be ', '. Pandas doesn't support multi
#character delimiters.
dh1CC.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CC.csv',sep =',',date_format='%m/%d/%Y %H:%M', header = False)
dh2CC.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2CC.csv',sep =',',date_format='%m/%d/%Y %H:%M', header = False)
dh1temp = np.loadtxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CC.csv', dtype =str , delimiter = ',')
dh2temp = np.loadtxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2CC.csv', dtype =str, delimiter = ',')
np.savetxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CC.csv',dh1temp,fmt= '%s', delimiter = ', ')
np.savetxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh2CC.csv',dh2temp,fmt = '%s', delimiter = ', ')
#


#
#
#K1 =  6.3021
#K2 = 'NA'
#q = -1*dh1*K1/0.3
#q['mean'] = np.mean(q['deltah'])
#plt.locator_params(numticks = 4)
#
#
#fig = plt.figure()
#ax = fig.add_subplot(111)
#
#
#f.plot(q['deltah'])
#ax.plot(q['mean'])
##plt.plot(dh2, color ='b')
#plt.xlabel('Date')
#plt.ylabel('q, m/d, positive is upwards ')
#plt.title('q TPB')
#plt.savefig("C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\TPB_q_TS.png")
#q.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\q Time series plots\\TPB_q_TS.csv', sep = ',', date_format='%m/%d/%Y %H:%M', header = False)
#
#
#plt.show()
#
#
#print np.mean(-1*dh1['deltah']*K1/0.3)