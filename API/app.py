import os, glob
import cv2 as cv
import numpy as np
from PIL import Image
import tensorflow as tf
from transformers import pipeline
from matplotlib import pyplot as plt
from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin

app = Flask(__name__)
CORS(app)

class_dict_type = {'banana': 0, 'potato': 1} #change
class_dict_type_rev = {0: 'banana', 1: 'potato'} #change

clas_dict_quality = {'Defected': 0, 'Fresh': 1, 'Half': 2}
clas_dict_quality_rev = {0: 'Defected', 1: 'Fresh', 2: 'Half'}

model_type = tf.keras.models.load_model('models/food type identification.h5')
model_type.compile(
            optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001), 
            loss='categorical_crossentropy', 
            metrics=[
                tf.keras.metrics.CategoricalAccuracy(name='accuracy'),
                tf.keras.metrics.Precision(name='precision'),
                tf.keras.metrics.Recall(name='recall'),
                tf.keras.metrics.AUC(name='auc')
                ])

model_quality = tf.keras.models.load_model('models/food quality identification.h5')
model_quality.compile(
                    optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001), 
                    loss='categorical_crossentropy', 
                    metrics=[
                        tf.keras.metrics.CategoricalAccuracy(name='accuracy'),
                        tf.keras.metrics.Precision(name='precision'),
                        tf.keras.metrics.Recall(name='recall'),
                        tf.keras.metrics.AUC(name='auc')
                        ])

anomaly_classifier = pipeline(
                             "zero-shot-image-classification", 
                             model = "openai/clip-vit-large-patch14-336"
                             )

def inference_classification(
                            model, 
                            image_path,
                            preprocess_function
                            ):
    image = cv.imread(image_path)
    image = cv.cvtColor(image, cv.COLOR_BGR2RGB)
    image = cv.resize(image, (224, 224))
    image = preprocess_function(image)
    image = np.expand_dims(image, axis=0)
    prediction = model.predict(image, verbose=0).squeeze()
    return prediction

def inference_anomaly(
                     img_path,
                     text_queries = [
                                    "banana or potato",  #chnage
                                    "not banana or potato" #chnage
                                    ]
                    ):
    img = Image.open(img_path).convert('RGB')
    response = anomaly_classifier(img, candidate_labels = text_queries)
    scores = [r['score'] for r in response]
    labels = [r['label'] for r in response]

    max_id = np.argmax(scores)
    label = labels[max_id]
    return False if label == 'banana or potato' else True # chnage

def inference_pipeline(image_path):
    anomaly_flag = inference_anomaly(image_path)
    if anomaly_flag:
        return None, None
    
    quality_op = inference_classification(
                                        model_quality,              
                                        image_path,
                                        tf.keras.applications.mobilenet_v2.preprocess_input
                                        )
    type_op = inference_classification(
                                        model_type,
                                        image_path,
                                        tf.keras.applications.mobilenet_v2.preprocess_input
                                        )
    
    quality_op = int(np.argmax(quality_op).squeeze())
    type_op = int(np.argmax(quality_op).squeeze())

    type_op = class_dict_type_rev[type_op]
    quality_op = clas_dict_quality_rev[quality_op]

    return type_op, quality_op

@app.route('/predict', methods=['POST'])
def predict():
    img_file = request.files['image']
    img_path = 'uploads/' + img_file.filename
    img_file.save(img_path)

    type_op, quality_op = inference_pipeline(img_path)
    if (type_op is None) and (quality_op is None):
        return jsonify({'error': 'Anomaly detected in image.'})
    else:
        return jsonify({'type': type_op, 'quality': quality_op})
    
if __name__ == '__main__':
    app.run(debug=True)