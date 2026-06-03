import csv
import numpy as np
def load_data(file_path="data/dataset.csv"):
    mots = []
    classements = []
    with open(file_path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            mots.append(row["mot"])
            classements.append(row["classe"])
        vocabulaire = np.unique(mots)
        word_to_index={str(word):i for i, word in enumerate(vocabulaire)}
        print(word_to_index)
        def one_hot(word):
            vector = np.zeros(len(vocabulaire))
            vector[word_to_index[word]] = 1
            return vector
        X = np.array([one_hote(w) for w in mots])
        Y = np.array([1 if cl == "cuisine" else -1 for cl in classements])
        print(X)
        print(Y)
        return X, Y, vocabulaire, word_to_index

load_data()
