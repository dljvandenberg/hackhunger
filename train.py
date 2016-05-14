import numpy
from random import shuffle

from keras.layers import Dropout, Dense
from keras.models import Sequential
from keras.optimizers import Adam
import csv


raw_data = []
with open('data/yemen_mvam_normalized.csv', 'rb') as csvfile:
     csvReader = csv.reader(csvfile, delimiter=',', quotechar='"')
     for row in csvReader:
         raw_data.append(row[45:50])
raw_data = raw_data[1:]
shuffle(raw_data)

trainingData = numpy.asarray([x[0:3] for x in raw_data[0:18000]])
trainingLabels = numpy.asarray([x[3] for x in raw_data[0:18000]])
testData = numpy.asarray([x[0:3] for x in raw_data[18000:]])
testLabels = numpy.asarray([x[3] for x in raw_data[18000:]])

clf = Sequential()

clf.add(Dense(input_dim=3, output_dim=1600, activation='tanh'))
clf.add(Dropout(0.6))
clf.add(Dense(input_dim=1600, output_dim=1200, activation='tanh'))
clf.add(Dropout(0.6))
clf.add(Dense(input_dim=1200, output_dim=800, activation='tanh'))
clf.add(Dropout(0.6))
clf.add(Dense(input_dim=800, output_dim=1, activation='tanh'))

clf.compile(optimizer=Adam(), loss='mean_squared_error')

clf.fit(trainingData, trainingLabels, batch_size=64, nb_epoch=4, validation_data=(testData, testLabels), verbose=1)