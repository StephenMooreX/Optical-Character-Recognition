%----------------------------------------------------------------------
%                   Stephen Moore                   4/25/2020
%                   DSP Final Project
%             Text Detection in Natural Signage
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%                   Load Image
%         There are 5 signs within the imageset
%----------------------------------------------------------------------

colorImage = imread('images/sign2.jpg'); %load image

figure
imshow(colorImage)
title('Original Image')

%----------------------------------------------------------------------
%                   Image Pre-Processing
%
% preprocess.m
% segment.m
%----------------------------------------------------------------------

image = preprocess(colorImage);
image2 = segment(image);

figure
imshow(image)

figure
imshow(image2)

%----------------------------------------------------------------------
%           Finding the Maximally Stable External Region
%
% https://www.mathworks.com/help/vision/ref/detectmserfeatures.html
%----------------------------------------------------------------------

[mserRegions, mserConnComp] = detectMSERFeatures(image2,'RegionAreaRange',[200 8000],'ThresholdDelta',4);

imageDisplay(image, mserRegions, 'Maximally Stable External Regions');

%----------------------------------------------------------------------
%     Removing the Non-Text Regions Utilizing Geometric Properties
%
% https://www.mathworks.com/help/images/ref/regionprops.html
% https://www.mathworks.com/help/matlab/ref/polyshape.boundingbox.html
%----------------------------------------------------------------------

% Regionprops
mserStats = regionprops(mserConnComp,'BoundingBox','Eccentricity','Solidity','Extent','Euler','Orientation','Image');

% Aspect Ratio via BoundingBox 
bbox = vertcat(mserStats.BoundingBox);
w = bbox(:,3);
h = bbox(:,4);
aspectRatio = w./h;

% Threshold the data to utilizing regionprops
filt = aspectRatio' > 2; 
filt = filt | [mserStats.Eccentricity] > .995 ;
filt = filt | [mserStats.Solidity] < .3;
filt = filt | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.9;
filt = filt | [mserStats.EulerNumber] < -1;
filt = filt | [mserStats.Orientation] < -90;

% Remove said regions
mserStats(filt) = [];
mserRegions(filt) = [];

% Display what is left
imageDisplay(image, mserRegions, 'After Removal of Non-Text Areas Using Geometric Properties');

%----------------------------------------------------------------------
%     Removing the Non-Text Regions Utilizing Stroke Width
%
% https://www.mathworks.com/help/images/ref/bwdist.html
% https://www.mathworks.com/help/images/ref/bwmorph.html
%----------------------------------------------------------------------

% Pad the image
regionImage = mserStats(1).Image;
regionImage = padarray(regionImage, [1 1]);

% stroke width image
distanceImage = bwdist(~regionImage); 
skeletonImage = bwmorph(regionImage, 'thin', inf);

strokeWidthImage = distanceImage;
strokeWidthImage(~skeletonImage) = 0;

% Show the regions
figure
subplot(2,1,1)
imagesc(regionImage)
title('Region Image')

subplot(2,1,2)
imagesc(strokeWidthImage)
title('Stroke Width Image')

% stroke width variation metric 
strokeWidthValues = distanceImage(skeletonImage);   
strokeWidthMetric = std(strokeWidthValues)/mean(strokeWidthValues);

% stroke width variation metric
strokeWidthThreshold = 0.4;
strokeWidthFilt = strokeWidthMetric > strokeWidthThreshold;

% Process the remaining regions
for j = 1:numel(mserStats)
    
    regionImage = mserStats(j).Image;
    regionImage = padarray(regionImage, [1 1], 0);
    
    distanceImage = bwdist(~regionImage);
    skeletonImage = bwmorph(regionImage, 'thin', inf);
    
    strokeWidthValues = distanceImage(skeletonImage);
    
    strokeWidthMetric = std(strokeWidthValues)/mean(strokeWidthValues);
    
    strokeWidthFilt(j) = strokeWidthMetric > strokeWidthThreshold;
    
end

% Remove regions
mserRegions(strokeWidthFilt) = [];
mserStats(strokeWidthFilt) = [];

% Show remaining regions
imageDisplay(image, mserRegions, 'After Removing Based On Stroke Width Variation');

%----------------------------------------------------------------------
%           Create Bounding Boxes for MSER Regions
%
% https://www.mathworks.com/help/matlab/ref/vertcat.html
% https://www.mathworks.com/help/matlab/ref/polyshape.boundingbox.html
%----------------------------------------------------------------------

% Get bounding boxes for all the regions
bboxes = vertcat(mserStats.BoundingBox);

% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience.
xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

% Expand the bounding boxes by a small amount.
expansionAmount = 0.02;
xmin = (1-expansionAmount) * xmin;
ymin = (1-expansionAmount) * ymin;
xmax = (1+expansionAmount) * xmax;
ymax = (1+expansionAmount) * ymax;

% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1);
ymin = max(ymin, 1);
xmax = min(xmax, size(image,2));
ymax = min(ymax, size(image,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
IExpandedBBoxes = insertShape(image,'Rectangle',expandedBBoxes,'LineWidth',3);

figure
imshow(IExpandedBBoxes)
title('Expanded Bounding Boxes')

%----------------------------------------------------------------------
%                   Merge Bounding Boxes
%
% https://www.mathworks.com/help/vision/ref/bboxoverlapratio.html
% https://www.mathworks.com/help/matlab/ref/accumarray.html
%----------------------------------------------------------------------

% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);

% Set the overlap ratio between a bounding box and itself to zero to
% simplify the graph representation.
n = size(overlapRatio,1); 
overlapRatio(1:n+1:n^2) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);

% Merge the boxes based on the minimum and maximum dimensions.
xmin = accumarray(componentIndices', xmin, [], @min);
ymin = accumarray(componentIndices', ymin, [], @min);
xmax = accumarray(componentIndices', xmax, [], @max);
ymax = accumarray(componentIndices', ymax, [], @max);

% Compose the merged bounding boxes using the [x y width height] format.
textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];

%----------------------------------------------------------------------
%                   Remove Erroneous Boxes 
%
% https://www.mathworks.com/help/matlab/ref/histcounts.html
%----------------------------------------------------------------------

%Remove bounding boxes that only contain one text region
numRegionsInGroup = histcounts(componentIndices);
textBBoxes(numRegionsInGroup == 1, :) = [];

% Show the final text detection result.
ITextRegion = insertShape(image, 'Rectangle', textBBoxes,'LineWidth',3);

figure
imshow(ITextRegion)
title('Text Regions')

%----------------------------------------------------------------------
%                   Run OCR Function 
%
% https://www.mathworks.com/help/vision/ref/ocr.html
%----------------------------------------------------------------------

ocrtext = ocr(image, textBBoxes,  'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789');
output = [ocrtext.Text]

