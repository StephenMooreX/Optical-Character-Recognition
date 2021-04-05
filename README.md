# Optical-Character-Recognition
Example of Optical Character Recognition in MATLAB code. 

# Methodology
![image](https://user-images.githubusercontent.com/78608321/113637501-bbefe080-9642-11eb-952f-66a7d87ad240.png)
# Original Images
![image](https://user-images.githubusercontent.com/78608321/113637652-20ab3b00-9643-11eb-9746-ef628524eeb7.png)
# Images After Pre-Processing
![image](https://user-images.githubusercontent.com/78608321/113637659-27d24900-9643-11eb-87c9-2a05f6c5f2b2.png)
# Images After Segmentation
![image](https://user-images.githubusercontent.com/78608321/113637666-2e60c080-9643-11eb-9e1d-baca1305517c.png)
# MSER Images
![image](https://user-images.githubusercontent.com/78608321/113637672-328cde00-9643-11eb-8835-d1716260e51d.png)
# MERS After Applying Regionprops Removal
![image](https://user-images.githubusercontent.com/78608321/113637686-391b5580-9643-11eb-8335-603b378c41c4.png)
# Stroke Width Calculation
![image](https://user-images.githubusercontent.com/78608321/113637695-3de00980-9643-11eb-8146-cee56c7e352d.png)
# MSER After Removal of Non-Uniform Regions
![image](https://user-images.githubusercontent.com/78608321/113637703-42a4bd80-9643-11eb-8ae1-37175290e40a.png)
# MSER With Bounding Boxes
![image](https://user-images.githubusercontent.com/78608321/113637712-48020800-9643-11eb-92bd-a5a8c41392a8.png)
# Overlap Failure
![image](https://user-images.githubusercontent.com/78608321/113637721-4cc6bc00-9643-11eb-94aa-67d2491a8473.png)
# Results of OCR after Pre-Processing and MSER Application
![image](https://user-images.githubusercontent.com/78608321/113637738-52240680-9643-11eb-99dc-9c7cf76612ad.png)

# ~Conclusion
In conclusion, we can see that not only can OCR be improved, that there is still much more to do to achieve the highest possible accuracy. Computer vision can most definitely find success in real world scenarios by testing on natural images, versus close up images of characters like license plates or credit cards. While those are still useful, there is a lot more noise in images like these. Detecting where useful text is and recognizing those characters into meaningful words or sentences could have many applications. Perhaps something similar could be used in self-driving cars? Interpreting road signs might be a useful tool for that. 

However, for this to happen this method would need improvement. Signal processing can be greatly enhanced via machine learning methods. In this case a convolutional neural network could be utilized to improve the accuracy, and we already have the feature extraction methods ready. Many things could be improved such as the issue that was discovered regarding character spacing and the dropping of said characters. 

Regardless, this was as very entertaining exercise with digital signal processing, and I look forward to taking the time to improve upon it in the future. 
