# DOT pipeline
An automated pipeline for breast cancer diagnosis using US-assisted diffuse optical tomography.

**by Minghao Xue (https://opticalultrasoundimaging.wustl.edu/)**

![This is an image](https://github.com/OpticalUltrasoundImaging/DOT_GUI/blob/main/Figures/reconstruction.png)

## Abstract

Ultrasound (US)-guided diffuse optical tomography (DOT) is a portable and non-invasive imaging modality for breast cancer diagnosis and treatment response monitoring. However, DOT data pre-processing and imaging reconstruction often require labor intensive manual processing which hampers real-time diagnosis. In this study, we aim at providing an automated US-assisted DOT pre-processing, imaging and diagnosis pipeline to achieve near real-time diagnosis. We have developed an automated DOT pre-processing method including motion detection, mismatch classification using deep-learning approach, and outlier removal. US-lesion information needed for DOT reconstruction was extracted by a semi-automated lesion segmentation approach combined with a US reading algorithm.  A deep learning model was used to evaluate the quality of the reconstructed DOT images and a deep-learning fusion model is implemented to provide final diagnosis based on US imaging features and DOT measurements and imaging results. The presented US-assisted DOT pipeline accurately processed the DOT measurements and reconstruction and reduced the procedure time to 2 to 3 minutes while maintained a comparable classification result with manually processed dataset.

## Graphical user interface
This pipeline consists of two main windows, a pre-processing window, and an imaging window.
![This is an image](https://github.com/OpticalUltrasoundImaging/DOT_GUI/blob/main/Figures/GUI.png)

The pre-processing section includes motion detection, mismatch identification, phase unwrapping, and outlier removal. It generates the best and clean perturbation from target, reference, and intralipid measurements.
The imaging section employs US segmentation, DOT reconstruction, DOT image evaluation, and some diagnosis algorithm.

## Requirements
* Python: 3.7+
* torch(pytorch): 1.10+
* torchvision: 0.11.1+
* numpy: 1.21.2+
* scipy: 1.7.1+
* scikit-learn: 1.3+
* DEXTR (https://github.com/scaelles/DEXTR-PyTorch/)


## Contact

Please email Minghao Xue at m.xue@wustl.edu if you have any concerns or questions.
