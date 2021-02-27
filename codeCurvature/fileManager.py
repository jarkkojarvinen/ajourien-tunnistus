"""
Reads and writes DEM .csv maps.   
ptn 02.06.2018
"""
import sys,numpy as np

def readMML(fName):
    """ 
    Deciphers a potential header of MML z.asc files.
    Returns the header and the data. 
    """
    print('reading %s' % fName, file= sys.stderr)
    with open(fName,'r') as f:
        lines= f.readlines()

    # skip the header lines with not a float value as the first token
    i,headerLine,header= -1,True,dict([])
    while headerLine:
        i+= 1
        line= [token for token in lines[i].strip().split(' ') if token]
        headWord,nextWord= line[0],line[1]
        try: 
            x= float(headWord)
            headerLine= False
        except:
            header[headWord]= float(nextWord)

    header['nrows']= int(header['nrows'])
    header['ncols']= int(header['ncols'])
    return header,np.array([[float(x) for x in line.strip().split(' ') if x] for line in lines[i:]])

def writeMML(fName, header,data):
    """ 
    Writes the header and data as .asc files.
    """
    with open(fName,'w') as f:
        print('ncols  %d'        % aHeader['ncols'], file=f)
        print('nrows  %d'        % aHeader['nrows'], file=f)
        print('xllcorner  %f'    % aHeader['xllcorner'], file=f)
        print('yllcorner  %f'    % aHeader['yllcorner'], file=f)
        print('cellsize  %f'     % aHeader['cellsize'], file=f)
        print('NODATA_value  %f' % aHeader['NODATA_value'], file=f)
    with open(fName,'a') as f:
        for row in data:
            print(' '.join(['%.2f' % x for x in row]), file=f) 