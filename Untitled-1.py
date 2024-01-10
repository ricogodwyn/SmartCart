import jetson.inference
import jetson.utils
import time
import cv2
import numpy as np 
import serial
import threading
import os
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import Jetson.GPIO as GPIO
import time

class Data:
    def __init__(self, item, weight):
        self.item = item
        self.weight = weight
        self.in_count = 0
        self.out_count = 0
        self.prev_in_count = 0
        self.prev_out_count = 0
        self.qty = 0

    def calculate_in_out_count(self):
        if self.in_count > self.prev_in_count and self.out_count > self.prev_out_count:
            return (self.in_count - self.prev_in_count) - (self.out_count - self.prev_out_count)
        elif self.in_count > self.prev_in_count:
            return self.in_count - self.prev_in_count
        elif self.out_count > self.prev_out_count:
            return -(self.out_count - self.prev_out_count)
        else:
            return 0
        
        
class SharedData:
    def __init__(self):
        self.data_list = [Data('PringlesCheese', 39), Data('SmaxRing', 40), Data('IndomieGoreng', 80), Data('SedaapGoreng', 86)]
        self.weight = 0.00
        self.id = 0   
        self.flag = False    
    
    def get_id(self):
        return self.id
    
    def get_weight(self):
        return self.weight


cred = credentials.Certificate("/home/michelie/code/multithread/michelie-firebase-adminsdk-xligw-f71ba76f00.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
doc_ref = db.collection('user').document('dummyData').collection('itemList')
doc_ref_2 = db.collection('user').document('dummyData')


def jetsonTracking(shared_data):
    data_list = shared_data.data_list

    timeStamp = time.time()
    fpsFilt = 0

    # Initialize the neural network
    net = jetson.inference.detectNet(
        argv=["--model=ssd-mobilenet.onnx", "--labels=labels.txt", "--input-blob=input_0", "--output-cvg=scores", "--output-bbox=boxes"],
        threshold=0.80
    )

    # Set tracking parameters
    net.SetTrackerType("IOU")
    net.SetTrackingEnabled(True)
    net.SetTrackingParams(minFrames=3, dropFrames=15, overlapThreshold=0.7)

    # Display window dimensions
    dispW = 640
    dispH = 480
    font = cv2.FONT_HERSHEY_SIMPLEX
    roi_bound = dispH / 2

    prevPosition = {}
    ID = 0

    # Initialize camera
    cam = cv2.VideoCapture('/dev/video0')
    cam.set(cv2.CAP_PROP_FRAME_WIDTH, dispW)
    cam.set(cv2.CAP_PROP_FRAME_HEIGHT, dispH)

    while True:
        _, img = cam.read()
        height, width = img.shape[:2]

        frame = cv2.cvtColor(img, cv2.COLOR_BGR2RGBA).astype(np.float32)
        frame = jetson.utils.cudaFromNumpy(frame)
        detections = net.Detect(frame, width, height)

        for detect in detections:
            ID = detect.ClassID
            top, left, bottom, right = detect.Top, detect.Left, detect.Bottom, detect.Right
            item = net.GetClassDesc(ID)
            track_id = detect.TrackID
            currentCentroid = detect.Center[1]
           
            if track_id != -1:
                if track_id in prevPosition:
                    previousCentroid = prevPosition[track_id]
                    if previousCentroid < roi_bound and currentCentroid >= roi_bound:
                        # in_count += 1
                        if ID != 0:
                            data_list[ID-1].in_count += 1
                            shared_data.flag = True
                        
                    elif previousCentroid > roi_bound and currentCentroid <= roi_bound:
                        # out_count += 1
                        if ID != 0:
                            data_list[ID-1].out_count += 1
                            shared_data.flag = True

                prevPosition[track_id] = currentCentroid

            cv2.rectangle(img, (int(left), int(top)), (int(right), int(bottom)), (255, 0, 0), thickness=2)
            cv2.putText(img, item, (int(left), int(top)), font, 1, (255, 0, 0), 2)

        dt = time.time() - timeStamp
        timeStamp = time.time()
        fps = 1 / dt
        fpsFilt = 0.9 * fpsFilt + 0.1 * fps

        cv2.putText(img, str(round(fpsFilt, 1)) + ' fps', (0, 30), font, 1, (0, 0, 255), 2)
        if ID == 0:
            cv2.putText(img, 'No object detected', (0, 60), font, 1, (0, 0, 255), 2)
        else:
            shared_data.id = ID-1
            cv2.putText(img, 'Curr In ' + str(data_list[ID-1].item) + ': ' + str(data_list[ID-1].in_count), (0, 60), font, 1, (0, 0, 255), 2)
            cv2.putText(img, 'Curr Out ' + str(data_list[ID-1].item) + ': ' + str(data_list[ID-1].out_count), (0, 90), font, 1, (0, 0, 255), 2)
            cv2.putText(img, 'Prev In ' + str(data_list[ID-1].item) + ': ' + str(data_list[ID-1].prev_in_count), (0, 120), font, 1, (0, 0, 255), 2)
            cv2.putText(img, 'Prev Out ' + str(data_list[ID-1].item) + ': ' + str(data_list[ID-1].prev_out_count), (0, 150), font, 1, (0, 0, 255), 2)
            cv2.putText(img, 'Weight: ' + str(data_list[ID-1].weight-10) + ', ' + str(data_list[ID-1].weight+10), (0, 180), font, 1, (0, 0, 255), 2)
            cv2.putText(img, 'Qty ' + str(data_list[ID-1].item) + ': ' + str(data_list[ID-1].qty), (0, 210), font, 1, (0, 0, 255), 2)

        cv2.imshow('detCam', img)
        cv2.moveWindow('detCam', 0, 0)

        if cv2.waitKey(1) == ord('q'):
            break

    cam.release()
    cv2.destroyAllWindows()

def weight(port, shared_data):
    # Open the serial port outside the while loop
    with serial.Serial(port, 9600) as ser:
        message = bytearray()  # Create an empty bytearray to accumulate the bytes
        try:
            while True:
                # Read a byte from the ESP32
                byte = ser.read(1)
                if byte:
                    message.extend(byte)  # Append the byte to the message bytearray
                    if byte == b'\n':  # Check if the byte is a newline character
                        try:
                            data = message.decode('utf-8').strip()
                            print('output :', data)
                            try:
                                data_float = float(data)
                                shared_data.weight = data_float
                            except ValueError:
                                # Handle the case where data is not a valid integer
                                print(f"Invalid data for comparison: {data}")
                        except UnicodeDecodeError:
                            print("Received a non UTF-8 encoded byte sequence.")
                        message = bytearray()  # Reset the message bytearray for the next message
        except KeyboardInterrupt:
            pass  # Exit on Ctrl+C
        finally:
            # Close the serial port
            ser.close()

def perbandingan(shared_data):
    data_list = shared_data.data_list
    prevWeight = 0
    currWeight = 0
    weight = 0
    ncounter = 0
    waiting = False
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(33, GPIO.OUT)
    
    while True:
        currWeight = shared_data.weight
        ##create time integer YYYYMMHHDDHHMMSS
        now = datetime.now()
        formatted_datetime = int(now.strftime("%Y%m%d%H%M%S"))
        if shared_data.flag == True:
            ID = shared_data.id
            inoutval = data_list[ID].calculate_in_out_count()
            weight = data_list[ID].weight
            print('Inoutval: ', inoutval)

            if inoutval == 0:
                data_list[ID].in_count = data_list[ID].prev_in_count
                data_list[ID].out_count = data_list[ID].prev_out_count
                shared_data.flag = False
                waiting = False
            elif inoutval > 0:
                if (weight-25) <= currWeight - prevWeight <= (weight+25):
                    data_list[ID].qty += 1
                    data_list[ID].prev_in_count += 1
                    data_list[ID].in_count = data_list[ID].prev_in_count
                    prevWeight = currWeight
                    update_firestore(data_list[ID].item, {'quantity' : data_list[ID].qty, 'waktu' : formatted_datetime})
                    print("jumlah barang yang masuk : ", 1)
                    ncounter = 0
                    waiting = False
                    GPIO.output(33, GPIO.LOW)
                else:
                    print('berat beda')
                    ncounter += 1
                    if (ncounter == 15):
                        data_list[ID].in_count = data_list[ID].prev_in_count
                        data_list[ID].out_count = data_list[ID].prev_out_count
                        shared_data.flag = False
                        ncounter = 0
                        GPIO.output(33, GPIO.HIGH)

            elif inoutval < 0:
                if-(weight-25) >= currWeight - prevWeight >= -(weight+25):
                    data_list[ID].qty -= 1
                    data_list[ID].prev_out_count += 1
                    data_list[ID].out_count = data_list[ID].prev_out_count
                    prevWeight = currWeight
                    update_firestore(data_list[ID].item, {'quantity' : data_list[ID].qty, 'waktu' : formatted_datetime})
                    print("jumlah barang yang keluar : ", 1)
                    ncounter = 0
                    waiting = False
                # else:
                #     print('berat beda')
                #     ncounter += 1
                #     if (ncounter == 5):
                #         data_list[ID].prev_in_count = data_list[ID].in_count
                #         data_list[ID].prev_out_count = data_list[ID].out_count
                #         shared_data.flag = False
                #         ncounter = 0

        elif shared_data.flag == False and waiting == False:
            print('No change waiting...')
            waiting = True
        
        print("Current Weight: ", currWeight - prevWeight)
        time.sleep(1)

def update_firestore(document, data):
    try:
        doc_ref = db.collection('user').document('dummyData').collection('itemList').document(document)
        doc_ref.update(data)
        print(f"Firestore updated: {data}")

    except Exception as e:
        print(f"Error updating Firestore: {e}")

if __name__ == '__main__':
    shared_data = SharedData()

    thread1 = threading.Thread(target=jetsonTracking, args=(shared_data,))
    thread2 = threading.Thread(target=weight, args =('/dev/ttyTHS1', shared_data,) )
    thread3 = threading.Thread(target=perbandingan, args=(shared_data,))


    thread1.start()
    thread2.start()
    thread3.start()
    

    thread1.join()
    thread2.join()
    thread3.join()
 

    print("Threads have finished execution.")


