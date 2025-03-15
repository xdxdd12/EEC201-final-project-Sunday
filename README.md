# **Speaker Identification System**

## **Project Background**
### **Introduction**
Speaker recognition is the process of **automatically identifying who is speaking** based on unique characteristics embedded in speech signals. This technology is widely used in applications such as **biometric authentication, security systems, and voice assistants**.

This project builds a **simple yet effective speaker recognition system** using **Mel-Frequency Cepstral Coefficients (MFCC)** for feature extraction and **Vector Quantization (VQ) with the Linde-Buzo-Gray (LBG) algorithm** for pattern classification.

### **Technical Principles**
Speaker recognition systems generally consist of **two phases**:
1. **Training (Enrollment) Phase**:
   - The system extracts features from speech samples of known speakers.
   - A reference model (codebook) is generated for each speaker.
2. **Testing (Operational) Phase**:
   - The system extracts features from an **unknown speech sample**.
   - The extracted features are compared to stored speaker models.
   - The system identifies the speaker based on the **minimum distortion measure**.

The **MFCC method** is used for **speech feature extraction** because:
- It mimics **human auditory perception**, which is **more sensitive to lower frequencies**.
- It reduces **redundant data** while preserving important phonetic features.
- It is **robust to background noise and variations** in speech.

The **Vector Quantization (VQ) technique**, specifically using the **Linde-Buzo-Gray (LBG) algorithm**, is adopted because:
- It is computationally efficient compared to more complex deep learning models.
- It effectively **clusters similar feature vectors** for each speaker.
- It allows for **quick classification** by measuring the distortion between input features and stored codebooks.

## **Project Structure**
The system follows these main steps:

- **Preprocessing**: Extract MFCC features from speech signals.  
- **Training**: Build speaker-specific codebooks using the LBG algorithm.  
- **Testing**: Classify test speech samples using trained codebooks.  
- **Evaluation**: Assess system performance under various test conditions.  

---

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

## **Test Results & Improvement Strategies**
During the testing process, we gradually improved system performance by modifying several key aspects.

### **TEST 1: Human Recognition Rate**
- **Initial accuracy:** 25% (training), 12.5% (test)  
- **After multiple listens:** 87.5% (training), 100% (test)  
- **Improvement Strategy:**  
  - Recognized that human perception alone is **not reliable for speaker identification**.  
  - Used **MFCC features** instead of direct waveform comparison.
### **TEST 2: Spectrogram Analysis**
- **FFT sizes tested:** `N = 128`, `N = 256`, `N = 512`  
- **Observation:**  
  - The **energy distribution** of the signal changes with frame size.
  - Optimal **windowing and frame increment (N/3)** was selected.
<table>
  <tr>
    <td><img src="final report plots/test2_128t.png" width="300"></td>
    <td><img src="final report plots/test2_128f.png" width="300"></td>
  </tr>
  <tr>
    <td><img src="final report plots/test2_256t.png" width="300"></td>
    <td><img src="final report plots/test2_256f.png" width="300"></td>
  </tr>
  <tr>
    <td><img src="final report plots/test2_512t.png" width="300"></td>
    <td><img src="final report plots/test2_512f.png" width="300"></td>
  </tr>
</table>

### **TEST 3: Mel Filter Bank Analysis**
- **Improvement:**  
  - Minor distortions were observed in the filter bank response.  
  - Adjusted **filter spacing and triangle shapes** for better feature extraction.

### **TEST 5 & TEST 6: MFCC Scatter Plot & VQ Codebook Visualization**
- **Observation:**  
  - Clustering was **visible** but **overlapping** between similar voices.  
  - Trained the **LBG algorithm** with increased centroids for better separation.

### **TEST 7: Speaker Recognition Accuracy**
- **Initial accuracy:** 100% on training and test datasets.  
- **Improvement:**  
  - Added **more speakers** to test **scalability**.

### **TEST 8: Notch Filter Impact**
- **Observation:**  
  - Notch filtering **caused minor misclassification**.  
- **Improvement Strategy:**  
  - Increased **MFCC coefficient count** to **retain more spectral details**.

### **TEST 9 & TEST 10: Speaker Expansion & Multi-class Testing**
- **Observation:**  
  - Increasing the number of speakers **slightly decreased accuracy**.  
  - Identifying between **"zero"/"twelve"** was harder than **"five"/"eleven"**.  
- **Final Accuracy:**  
  - **"zero"/"twelve"**: **91.7%**  
  - **"five"/"eleven"**: **100%**  

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
