# **Speaker Identification System**

## **Table of Contents**
- [Overview](#overview)
- [Project Structure](#project-structure)
- [Code Components](#code-components)
  - [speaker_identification.m](#1-speaker_identificationm)
  - [readSTFT.m](#2-readstftm)
  - [applyNotch.m](#3-applynotchm)
  - [melfb.m](#4-melfbm)
  - [compute_mfcc_from_spectrogram.m](#5-compute_mfcc_from_spectrogramm)
  - [LBG.m](#6-lbgm)
- [Test Results](#test-results)
- [Function Testing](#function-testing)
- [How to Run](#how-to-run)
- [Conclusion](#conclusion)

---

## **Overview**
This project implements a speaker identification system using **Mel-Frequency Cepstral Coefficients (MFCC)** and **Vector Quantization (VQ)** with the **Linde-Buzo-Gray (LBG)** algorithm. The system is trained to recognize different speakers based on their voice recordings.

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

[Back to Table of Contents](#table-of-contents)

---

### **2. `readSTFT.m`**
Reads an audio file and computes its **Short-Time Fourier Transform (STFT)**.

[Back to Table of Contents](#table-of-contents)

---

### **3. `applyNotch.m`**
Applies a **Notch filter** to remove specific frequencies.

[Back to Table of Contents](#table-of-contents)

---

### **4. `melfb.m`**
Computes the **Mel filter bank**.

[Back to Table of Contents](#table-of-contents)

---

### **5. `compute_mfcc_from_spectrogram.m`**
Computes **MFCC features** from a given spectrogram.

[Back to Table of Contents](#table-of-contents)

---

### **6. `LBG.m`**
Trains a speaker codebook using the **LBG (Linde-Buzo-Gray) algorithm**.

[Back to Table of Contents](#table-of-contents)

---

## **Test Results**
- **[TEST 1: Human Recognition Rate](#test-1-human-recognition-rate)**
- **[TEST 2: Spectrogram Analysis](#test-2-spectrogram-analysis)**
- **[TEST 3: Mel Filter Bank Analysis](#test-3-mel-filter-bank-analysis)**
- **[TEST 5: MFCC Scatter Plot](#test-5-mfcc-scatter-plot)**
- **[TEST 6: Codebook Visualization](#test-6-codebook-visualization)**
- **[TEST 7: Speaker Recognition Accuracy](#test-7-speaker-recognition-accuracy)**
- **[TEST 8: Notch Filter Impact](#test-8-notch-filter-impact)**
- **[TEST 9: Expanded Speaker Set](#test-9-expanded-speaker-set)**
- **[TEST 10a: Zero vs Twelve Identification](#test-10a-zero-vs-twelve-identification)**
- **[TEST 10b: Five vs Eleven Identification](#test-10b-five-vs-eleven-identification)**

[Back to Table of Contents](#table-of-contents)

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
