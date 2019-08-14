# Compressed Video Action Recognition
This Repository is Implementation Code of Proposed Method in [Action Recognition in Compressed Domain Using Residual Information](https://ieeexplore.ieee.org/document/8785055) Paper.

## Abstract
Practically, action recognition using deep learning approaches are slow because of high temporal redundancy and large size of the raw video data. One of the solutions for boosting accuracy is calculating optical flows. 

Generally, extracting motion features are too time-consuming. Therefore, traditional action recognition methods are not suitable for real time applications. On the other hand, compressed videos are available in many situations especially when using mobile devices. We proposed a method that extracts residuals directly from compressed videos by partially decoding the video and feed them to a deep neural network. 

In general, exploiting the compressed domain features as available information provides a slight reduction in accuracy while the low complexity of this method makes it appropriate for real time applications. 

The experimental results on multiple first and third person datasets exhibit that while the proposed method provides low computational complexity, the results are highly competitive with traditional approaches in accuracy.

## Prerequisites

#### 1. Pre-Trained CNN:
>We Used [imagenet-vgg-f](http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat) as The Pre-Trained CNN For Feature Extraction.
Download and Copy it to The Root Folder of Project.

#### 2. MMRead
>In Order To Read Video Frames, We Used mmread MATLAB Library. You Can Download it from [here]>>(https://www.mathworks.com/matlabcentral/fileexchange/8028-mmread)

#### 3. LIBSVM
>LIBSVM is an integrated software for support vector classification, (C-SVC, nu-SVC), regression (epsilon-SVR, nu-SVR) and distribution estimation (one-class SVM). It supports multi-class classification. This Library and it's Documentation Are Available [here](https://www.csie.ntu.edu.tw/~cjlin/libsvm/). Our Version is: libsvm-3.22

