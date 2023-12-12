%% Introduction

% Functions:
% 
% 'hough' computes the Standard Hough Transform (SHT) of the binary image BW
% [H,theta,rho] = hough(BW), H = Hough transform matrix, theta = angle
% between x-axis and rho vector, rho = distance from origin to line
%
% 'houghpeaks' identify peaks in Hough transform
% peaks = houghpeaks(H,numpeaks), H = Hough transform matrix 
% rect = [xmin ymin width height] % 1250 for both, 550 for only one

I = imread('jarrudyn_04.png'); % importing the image

%% Preprocessing

Imcrop = imcrop(I,[10 70 550 550]); % crop

BW = imbinarize(Imcrop,0.45); % thresholding

invI = imcomplement(BW); % invert

kk = bwareaopen(invI, 1200); % remove small objects

k = edge(kk,'approxcanny'); % edge extraction

figure
subplot(2,3,1)
imshow(I)
title('original image')
subplot(2,3,2)
imshow(Imcrop)
title('cropped image')
subplot(2,3,3)
imshow(BW)
title('thresholding')
subplot(2,3,4)
imshow(invI)
title('inverted image')
subplot(2,3,5)
imshow(kk)
title('removing small objects')
subplot(2,3,6)
imshow(k)
title('edge extraction')

%% hough and houghpeaks

[H,T,R] = hough(k);

figure
imshow(imadjust(rescale(H)),'XData',T,'YData',R,'InitialMagnification','fit')
axis normal
hold on

P = houghpeaks(H,2,"Threshold",0.3*max(H(:)));

plot(T(P(:,2)),R(P(:,1)),'s','color','red');
xlabel('\theta'), ylabel('\rho');
axis on

%% peaks

meanP = (T(P(1,2))+T(P(2,2)))/2

if meanP>=0
    angle = meanP-43.5
else
    angle = 90-43.5+90-abs(meanP)
end

value = angle*3/(180-43.5)






