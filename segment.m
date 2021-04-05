%----------------------------------------------------------------------
%                   Stephen Moore                   4/25/2020
%                   DSP Final Project
% Binarize a 2D image, adjust for change in foreground brightness
%           
%
% https://www.mathworks.com/help/images/ref/imbinarize.html
%----------------------------------------------------------------------
function result = segment(I) 

BW = imbinarize(I,'adaptive','ForegroundPolarity','dark','Sensitivity',0.6);
result = BW;

end