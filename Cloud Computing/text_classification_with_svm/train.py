import numpy as np

from data_loader import load_data
from models_utils import  save_model

def train():
    X, Y, vocabulaire, word_to_index= load_data()
    b= 0
    lr= 0.1
    epochs= 50
    a = np.zeros(len(vocabulaire)) + 1
    for _ in ranges(epochs):
          for i in range(len(X)):
              X_i = X[i]
              Y_i = Y[i]
              condition= Y_i * (np.dot(a,X_i) + b)
              if condition  >= 1:
                   a = a - lr * (2 * a)
              else:
                  a = a - lr * (2*a - Y_i * X_i)
                  b = b - lr * ( -Y_i)
              model = {
                  "a" : a,
                  "b" : b,
                  "vocabulaire" : vocabulaire,
                  "word_to_index" : word_to_index
              }
              save_model(model)
              return model
train()


