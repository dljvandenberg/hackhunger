import numpy
from random import shuffle

from keras.layers import Dropout, Dense
from keras.models import Sequential
from keras.optimizers import Adam
import csv

from matplotlib.mlab import frange

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

#clf.save_weights('models/version1')
#clf.fit(trainingData, trainingLabels, batch_size=64, nb_epoch=4, validation_data=(testData, testLabels), verbose=1)

clf.load_weights('models/version1')


x = 0.01457496 # 10 kilometer
y = 0.02627294 # 10 kilometer
time = 0.05 # 1/5 month



for timeC in frange(-1, 1, time):
    coords = []
    for xC in frange(-1, 1, x):
        for yC in frange(-1, 1, y):
            coords.append([xC, yC, timeC]);

    predictions = clf.predict(numpy.asarray(coords), batch_size=1000)
    with open('output/' + str(timeC) + '.csv', 'w') as csvfile:
        datawriter = csv.writer(csvfile, delimiter=',',
                    quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for prediction in predictions:
            datawriter.writerow([xC, yC, prediction[0]])
