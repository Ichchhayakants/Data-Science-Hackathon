#!/usr/bin/env python
# coding: utf-8

# In[12]:


# Pandas is used for data manipulation
import pandas as pd
# Read in data and display first 5 rows
train = pd.read_csv('C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS/newtraindata.csv')
train.head(5)


# In[13]:


print('The shape of our features is:', train.shape)


# In[14]:


test = pd.read_csv('C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS/newtestdata.csv')


# In[15]:


# One-hot encode the data using pandas get_dummies
features = pd.get_dummies(train)
# Display the first 5 rows of the last 12 columns
train.iloc[:,5:].head(5)


# In[16]:


feature_list = list(train.columns)
print(feature_list)


# In[17]:


# Use numpy to convert to arrays
import numpy as np
# Labels are the values we want to predict
labels = np.array(train['loan_default'])
# Remove the labels from the features
# axis 1 refers to the columns
features= train.drop('loan_default', axis = 1)
# Saving feature names for later use
feature_list = list(train.columns)
# Convert to numpy array
features = np.array(train)


# In[21]:


print(train)


# In[39]:


x = train.drop(['loan_default'], axis=1)
y = train['loan_default'];


# In[41]:


# Import the model we are using
from sklearn.ensemble import RandomForestRegressor
# Instantiate model with 1000 decision trees
rf = RandomForestRegressor(n_estimators = 1000, random_state = 42)
# Train the model on training data
rf.fit(x,y);


# In[42]:


# Use the forest's predict method on the test data
predictions = rf.predict(test)
# Calculate the absolute errors
#errors = abs(predictions - test_labels)
# Print out the mean absolute error (mae)
#print('Mean Absolute Error:', round(np.mean(errors), 2), 'degrees.')
#Mean Absolute Error: 3.83 degrees.


# In[43]:


print(predictions)


# In[53]:


print(type(predictions))


# In[54]:


pred = []
for i in predictions:
    if i < 0.5:
        pred.append(0)
    else:
        pred.append(1)


# In[55]:


print(pred)


# In[57]:


fp = open("out.csv","w")
fp.write(repr(pred))
