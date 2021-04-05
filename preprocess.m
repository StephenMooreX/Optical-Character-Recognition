%----------------------------------------------------------------------
%                   Stephen Moore                   4/25/2020
%                   DSP Final Project
%             Pre-Processing Initial Image
%
% https://www.mathworks.com/help/images/ref/imadjust.html
% https://www.mathworks.com/help/images/ref/medfilt2.html
%----------------------------------------------------------------------
function result = preprocess(I)

bwImage = rgb2gray(I); %set image to grayscale

contrastImage = imadjust(bwImage,[0.4 0.7],[]); %set contrast limits 

filteredImage = medfilt2(contrastImage); %2D median filtering 

result = filteredImage;

end