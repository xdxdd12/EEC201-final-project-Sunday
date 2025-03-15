# **Speaker Identification System**

## **Overview**
This project implements a speaker identification system using **Mel-Frequency Cepstral Coefficients (MFCC)** and **Vector Quantization (VQ)** with the **Linde-Buzo-Gray (LBG)** algorithm. The system is trained to recognize different speakers based on their voice recordings.

## **Project Structure**
The system follows these main steps:

- **Preprocessing**: Extract MFCC features from speech signals.  
- **Training**: Build speaker-specific codebooks using the LBG algorithm.  
- **Testing**: Classify test speech samples using trained codebooks.  
- **Evaluation**: Assess system performance under various test conditions.  

## **Code Components**

### **1. `speaker_identification.m`**
This is the main script that performs both **training and testing**.

#### **Parameters:**
- **N** = 512 → FFT size  
- **numFilters** = 30 → Number of Mel filters  
- **numCoeffs** = 20 → Number of MFCC coefficients  
- **numCentroids** = 12 → Number of LBG centroids  
- **epsilon** = 0.005 → LBG error threshold  
- **applyNotchFilter** = false → Whether to apply a notch filter  

#### **Functionality:**
1. **Training Phase**
   - Reads training speech files from **`GivenSpeech_Data_training/Eleven Training/`**
   - Extracts **MFCC features** from spectrograms
   - Uses the **LBG algorithm** to create speaker-specific codebooks

2. **Testing Phase**
   - Reads test files from **`GivenSpeech_Data_test/Eleven Test/`**
   - Extracts **MFCC features**
   - Compares test MFCCs with trained codebooks
   - Classifies test samples to predict speakers

#### **Output:**
- Prints **predicted speaker labels** for each test file.

---

### **2. `readSTFT.m`**
Reads an audio file and computes its **Short-Time Fourier Transform (STFT)**.

#### **Parameters:**
- **filename** → Path to the audio file  
- **N** → FFT size  
- **applyNotchFilter** → Boolean flag to apply a notch filter  

#### **Output:**
- **S**: Spectrogram matrix  
- **F**: Frequency bins  
- **T**: Time bins  
- **fs**: Sampling rate  

---

### **3. `applyNotch.m`**
Applies a **Notch filter** to remove specific frequencies.

#### **Output:**
- Filtered speech signal  

---

### **4. `melfb.m`**
Computes the **Mel filter bank**.

#### **Output:**
- **melFilterBank**: A matrix of filter coefficients  

---

### **5. `compute_mfcc_from_spectrogram.m`**
Computes **MFCC features** from a given spectrogram.

#### **Output:**
- **mfccs**: Matrix of extracted MFCC features  

---

### **6. `LBG.m`**
Trains a speaker codebook using the **LBG (Linde-Buzo-Gray) algorithm**.

#### **Output:**
- **codebook**: A matrix of centroid points  

---

## **Test Results**
The system was evaluated using various test scenarios. Below are the results:

### **TEST 1: Human Recognition Rate**
- **Initial accuracy:** 25% (training), 12.5% (test)  
- **After multiple listens:** 87.5% (training), 100% (test)  

### **TEST 2: Spectrogram Analysis**
- **FFT sizes tested:** `N = 128`, `N = 256`, `N = 512`  

### **TEST 3: Mel Filter Bank Analysis**
- Extracted features effectively.  

### **TEST 5: MFCC Scatter Plot**
- Clustering observed but **some overlap** exists.  

### **TEST 6: Codebook Visualization**
- LBG algorithm **successfully differentiates speakers**.  

### **TEST 7: Speaker Recognition Accuracy**
- **100% accuracy** on training and test datasets.  

### **TEST 8: Notch Filter Impact**
- Some minor misclassifications (e.g., `s3.wav`).  

### **TEST 9: Expanded Speaker Set**
- **94.4% accuracy** (lower than TEST 7).  

### **TEST 10a: Zero vs Twelve Identification**
- **Accuracy: 91.7%**  
- Some misclassifications occurred.  

### **TEST 10b: Five vs Eleven Identification**
- **100% accuracy**  

---

## **Function Testing**
Each function in this project has been **modularized** and stored as a separate script.  

- You can find these individual function files in the **`func/test/`** folder.  
- Each function file follows the same naming convention as described in the sections above.  
- This allows you to **independently test each function** before integrating them into the full pipeline.  

For example:
```matlab
% To test the Mel filter bank function independently
melFilterBank = melfb(30, 512, 16000);
disp(melFilterBank);

---

## **How to Run**
1. Place training and test speech files in your desired folder and remember to change the folder name in the code to that one.
2. Run:
speaker_identification()
