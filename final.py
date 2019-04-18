#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
# Read in data and display first 5 rows
train = pd.read_csv('C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS/newtraindata.csv')


# In[14]:


test = pd.read_csv('C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS/newtest1.csv')


# In[15]:


test.columns


# In[17]:


test.shape


# In[3]:


print('The shape of our features is:', train.shape)


# In[4]:


train.columns


# In[5]:


train = train.drop(['Unnamed: 0'], axis=1)


# In[ ]:


test = test.drop(['Unnamed: 0'], axis=1)


# In[19]:


test.shape


# In[6]:


x = train.drop(['loan_default'], axis=1)
y = train['loan_default'];


# In[7]:


train.columns


# In[9]:


train.head


# In[10]:


x.shape


# In[11]:


y.shape


# In[12]:


from sklearn.ensemble import RandomForestRegressor
# Instantiate model with 1000 decision trees
rf = RandomForestRegressor(n_estimators = 1000, random_state = 42)
# Train the model on training data
rf.fit(x,y);


# In[20]:


predictions = rf.predict(test)


# In[21]:


print(predictions)


# In[29]:


predictions.shape


# In[36]:


sol = pd.DataFrame(predictions)


# In[38]:


sol.shape


# In[39]:


sol.to_csv("out1.scv", sep='\n')


# In[40]:


pred = []
for i in predictions:
    if i < 0.5:
        pred.append(0)
    else:
        pred.append(1)


# In[41]:


sol1 = pd.DataFrame(pred)


# In[42]:


print(sol1)


# In[26]:


fp = open("out.csv","w")
fp.write(repr(pred))


# In[46]:


sol1.to_csv("out3.csv")

