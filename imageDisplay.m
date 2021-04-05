%----------------------------------------------------------------------
%                   Stephen Moore                   4/24/2020
%                   DSP Final Project
%                   Simple Image Figure
%----------------------------------------------------------------------
function result = imageDisplay(I, J, K)

figure
result = imshow(I);
hold on
plot(J, 'showPixelList', true,'showEllipses',false);
title(K);
hold off

end