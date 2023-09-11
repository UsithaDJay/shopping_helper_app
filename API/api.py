from flask import Flask, request, jsonify
import cv2
import numpy as np
import os
from roboflow import Roboflow
import logging

app = Flask(__name__)

# Initialize Roboflow API with your API key
rf = Roboflow(api_key="dE6zZPFFQwCIaDFPwGAB")
rf2 = Roboflow(api_key="Sw4eTrob1ED3VthOsHdU")
rf3 = Roboflow(api_key="dE6zZPFFQwCIaDFPwGAB")
rf4 = Roboflow(api_key="Sw4eTrob1ED3VthOsHdU")

rf5 = Roboflow(api_key="w3NnvaYr0J5SgWqRWefm")

# List of models to use for object detection
models = [
    rf.workspace().project("carrot-pinapple").version(2).model,
    rf.workspace().project("apple-detection-5d9rl").version(1).model,
    rf2.workspace().project("potato-gtxmy").version(1).model,
    rf3.workspace().project("watermelon-samples").version(1).model,
    rf4.workspace().project("tomates-gxrjf").version(7).model,
    rf.workspace().project("pineapple-d7uot").version(8).model
]

# List of models to use for object detection
models2 = [
    rf.workspace().project("trolley_detection").version(4).model,
    rf.workspace().project("shopping-cart-6g1zn").version(2).model,
    # rf.workspace().project("smartfarm_basket").version(3).model,
    rf.workspace().project("detect-o9dby").version(1).model,
    rf.workspace().project("object-detection-59nri").version(11).model,
    rf.workspace().project("cash-detector1").version(3).model
]

@app.route('/detect', methods=['POST'])
def detect_objects():
    try:
        image_file = request.files['image']
        image = cv2.imdecode(np.frombuffer(image_file.read(), np.uint8), -1)
        print(image_file)
        annotated_image = image.copy()

        highest_confidence_class = ""
        highest_confidence = 0

        for model in models:
            print(type(image), image.shape)
            predictions = model.predict(annotated_image, confidence=70, overlap=30).json()
            print("Predictions: ", predictions)

            for prediction in predictions['predictions']:
                confidence = int(float(prediction['confidence']) * 100)
                if confidence > highest_confidence:
                    highest_confidence_class = prediction['class']
                    highest_confidence = confidence

                if prediction['class'] == "corn":
                    response_data = {
                        "highest_confidence_class": "corn",
                        "confidence": confidence
                    }
                    print("corn")
                    return jsonify(response_data)

        #apple model


                elif prediction['class'] == "rotten-apple":
                    response_data = {
                        "highest_confidence_class": "rotten-apple",
                        "confidence": confidence
                    }
                    print("rotten-apple")
                    return jsonify(response_data)
                
                elif prediction['class'] == "fresh-apple":
                    response_data = {
                        "highest_confidence_class": "fresh-apple",
                        "confidence": confidence
                    }
                    print("fresh-apple")
                    return jsonify(response_data)
                
                elif prediction['class'] == "apple-fresh-30%":
                    response_data = {
                        "highest_confidence_class": "apple-fresh-30%",
                        "confidence": confidence
                    }
                    print("apple-fresh-30%")
                    return jsonify(response_data)
                
                elif prediction['class'] == "fresh banana":
                    response_data = {
                        "highest_confidence_class": "fresh banana",
                        "confidence": confidence
                    }
                    print("fresh banana")
                    return jsonify(response_data)
                
                elif prediction['class'] == "rotten banana":
                    response_data = {
                        "highest_confidence_class": "rotten banana",
                        "confidence": confidence
                    }
                    print("rotten banana")
                    return jsonify(response_data)
                
                elif prediction['class'] == "fresh banana 30%":
                    response_data = {
                        "highest_confidence_class": "fresh banana 30%",
                        "confidence": confidence
                    }
                    print("fresh banana 30%")
                    return jsonify(response_data)
                
                elif prediction['class'] == "freshpotato":
                    response_data = {
                        "highest_confidence_class": "freshpotato",
                        "confidence": confidence
                    }
                    print("freshpotato")
                    return jsonify(response_data)
                
                elif prediction['class'] == "rotten potato":
                    response_data = {
                        "highest_confidence_class": "rotten potato",
                        "confidence": confidence
                    }
                    print("rotten potato")
                    return jsonify(response_data)
                
                elif prediction['class'] == "potato fresh 30%":
                    response_data = {
                        "highest_confidence_class": "potato fresh 30%",
                        "confidence": confidence
                    }
                    print("potato fresh 30%")
                    return jsonify(response_data)
        #tomato
                elif prediction['class'] == "Tomato":
                    response_data = {
                        "highest_confidence_class": "Tomato",
                        "confidence": confidence
                    }
                    print("Tomato")
                    return jsonify(response_data)
                
                elif prediction['class'] == "tomato":
                    response_data = {
                        "highest_confidence_class": "tomato",
                        "confidence": confidence
                    }
                    print("tomato")
                    return jsonify(response_data)
                
                elif prediction['class'] == "Ripe":
                    response_data = {
                        "highest_confidence_class": "Ripe",
                        "confidence": confidence
                    }
                    print("Ripe")
                    return jsonify(response_data)

                elif prediction['class'] == "Semi_Ripe":
                    response_data = {
                        "highest_confidence_class": "Semi_Ripe",
                        "confidence": confidence
                    }
                    print("Semi_Ripe")
                    return jsonify(response_data)
            
                elif prediction['class'] == "Un_Ripe":
                    response_data = {
                        "highest_confidence_class": "Un_Ripe",
                        "confidence": confidence
                    }
                    print("Un_Ripe")
                    return jsonify(response_data)

                else:
                    response_data = {
                        "highest_confidence_class": "Unknown",
                        "confidence": confidence
                    }
                    print("Unknown")
                    return jsonify(response_data)
                
        response_data = {
            "highest_confidence_class": "Not Detected",
            "confidence": 0
        }
        print("Not Detected")
        return jsonify(response_data)
        

    except Exception as e:
        logging.error(f"An error occurred: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route('/layout', methods=['POST'])
def detect_layout():
    try:
        image_file = request.files['image']
        image = cv2.imdecode(np.frombuffer(image_file.read(), np.uint8), -1)
        print(image_file)
        annotated_image = image.copy()

        highest_confidence_class = ""
        highest_confidence = 0

        for model in models2:
            print(type(image), image.shape)
            predictions = model.predict(annotated_image, confidence=70).json()
            print("Predictions: ", predictions)

            if predictions['predictions']:
                for prediction in predictions['predictions']:
                    confidence = int(float(prediction['confidence']) * 100)
                    if confidence > highest_confidence:
                        highest_confidence_class = prediction['class']
                        highest_confidence = confidence

                    if prediction['class'] == "Trolley":
                        response_data = {
                            "highest_confidence_class": "Trolley",
                            "confidence": confidence
                        }
                        print("Trolley")
                        return jsonify(response_data)
                    
                    elif prediction['class'] == "wagen":
                        response_data = {
                            "highest_confidence_class": "wagen",
                            "confidence": confidence
                        }
                        print("wagen")
                        return jsonify(response_data)
                                    
                    elif prediction['class'] == "trolley":
                        response_data = {
                            "highest_confidence_class": "trolley",
                            "confidence": confidence
                        }
                        print("trolley")
                        return jsonify(response_data)
                                    
                    elif prediction['class'] == "basket":
                        response_data = {
                            "highest_confidence_class": "basket",
                            "confidence": confidence
                        }
                        print("basket")
                        return jsonify(response_data)
                                    
                    elif prediction['class'] == "plastic-bottle":
                        response_data = {
                            "highest_confidence_class": "plastic-bottle",
                            "confidence": confidence
                        }
                        print("plastic-bottle")
                        return jsonify(response_data)

                    elif prediction['class'] == "glass-bottle":
                        response_data = {
                            "highest_confidence_class": "glass-bottle",
                            "confidence": confidence
                        }
                        print("glass-bottle")
                        return jsonify(response_data)
                    
                    elif prediction['class'] == "plastic":
                        response_data = {
                            "highest_confidence_class": "plastic",
                            "confidence": confidence
                        }
                        print("plastic")
                        return jsonify(response_data)
                    
                    elif prediction['class'] == "can":
                        response_data = {
                            "highest_confidence_class": "can",
                            "confidence": confidence
                        }
                        print("can")
                        return jsonify(response_data)
                    
                    elif prediction['class'] == "cash":
                        response_data = {
                            "highest_confidence_class": "cash",
                            "confidence": confidence
                        }
                        print("cash")
                        return jsonify(response_data)
                    else:
                        response_data = {
                            "highest_confidence_class": "Unknown",
                            "confidence": confidence
                        }
                        print("Unknown")
                        return jsonify(response_data)
                        # response_data = {
                        #     "highest_confidence_class": "Unknown",
                        #     "confidence": confidence
                        # }
                        # return jsonify(response_data)
                
                print(highest_confidence_class)

        print(highest_confidence_class)
        response_data = {
            "highest_confidence_class": "Not Detected",
            "confidence": 0
        }
        print("Not Detected")
        return jsonify(response_data)

    except Exception as e:
        logging.error(f"An error occurred: {str(e)}")
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host=os.getenv("HOST", "0.0.0.0"), port=os.getenv("PORT", 80))
