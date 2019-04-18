from keras.models import Sequential
from keras.layers import Dense
import numpy
import pandas as pd
# fix random seed for reproducibility
numpy.random.seed(7)


# load pima indians dataset
train = pd.read_csv("C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS/newtraindata.csv")
test = pd.read_csv("C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS/newtestdata.csv")

X = train[:,0:40]
Y = train[:,41]

model = Sequential()
model.add(Dense(12, activation='relu'))
model.add(Dense(8, activation='relu'))
model.add(Dense(1, activation='sigmoid'))


# Compile model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])


# Fit the model
model.fit(X, Y, epochs=150, batch_size=10)


scores = model.evaluate(X, Y)
print("\n%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))

# calculate predictions
predictions = model.predict(test)
# round predictions
rounded = [round(x[0]) for x in predictions]
print(rounded)

fp = open("out.csv","w")
fp.write(repr(rounded))
