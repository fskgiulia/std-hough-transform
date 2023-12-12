%% Import data into cell 
data={};
for i=1:16
    if i<10
        data{i}=imread(['jarrudyn_0',num2str(i),'.png']);
    end
    if i>9
        data{i}=imread(['jarrudyn_',num2str(i),'.png']);
    end 
end
% display original data
figure(1);
for i=1:16
    subplot(4,4,i);
    imshow(data{i});
end

%% Crop the images into two 
% create one cell for the left goughs and one for the right goughs
for i=1:16
    left{i}=data{i}(75:550,25:570);
    right{i}=data{i}(75:550,710:1255);
end
figure(2);

for i=1:16
    subplot(4,4,i);
    imshow(right{i});
end
title('right')
figure(3);

for i=1:16
    subplot(4,4,i);
    imshow(left{i});
end
title('left')

%% Thresholding
threshold1=70;
threshold2=90;
for j=1:16
    for i=1:259896
        if left{j}(i)>threshold1
           left{j}(i)=255;
        end
        if right{j}(i)>threshold2
           right{j}(i)=255;
        end
    end
end
title('right')
figure(4);
for i=1:16
        subplot(4,4,i);
        imshow(right{i});
end
figure(5);
for i=1:16
    subplot(4,4,i);
    imshow(left{i});
end

%% invert

for j=1:16
    for i=1:259896
        left{j}(i)=255-left{j}(i);
        right{j}(i)=255-right{j}(i);
    end
end
figure(6);
for i=1:16
        subplot(4,4,i);
        imshow(right{i});
end
figure(7);
for i=1:16
    subplot(4,4,i);
    imshow(left{i});
end


%% remove small objects
for j=1:16
        left{j}=bwareaopen(left{j},1050);
        right{j}=bwareaopen(right{j},1200);
end
figure(6);
for i=1:16
        subplot(4,4,i);
        imshow(right{i});
end
figure(7);
for i=1:16
    subplot(4,4,i);
    imshow(left{i});
end

%% edge detection
close all
for j=1:16
        left{j}=edge(left{j},'approxcanny');
        right{j}=edge(right{j},'approxcanny');
end

close all
figure(6);
for i=1:16
        subplot(4,4,i);
        imshow(right{i});
end
figure(7);
for i=1:16
    subplot(4,4,i);
    imshow(left{i});
end
%% Hough transformation 
Angles=zeros(1,16);

for i=1:16
    % left
    [H_l{i}, THETA_l{i}, RHO_l{i}] = hough(left{i});
    Peaks_l{i}  = houghpeaks(H_l{i},2,"Threshold",0.3*max(H_l{i}(:))); %% getting the peaks in the H matrix
    % calcululating average angle of the two lines of the needle
    Angles_l(i)=0.5*(THETA_l{i}(Peaks_l{i}(1,2))  +  THETA_l{i}(Peaks_l{i}(2,2))); % calculating average angel 
    % right
    [H_r{i}, THETA_r{i}, RHO_r{i}] = hough(right{i});
    Peaks_r{i}  = houghpeaks(H_r{i},2,"Threshold",0.3*max(H_r{i}(:))); %% getting the peaks in the H matrix
    % calcululating average angle of the two lines of the needle
    Angles_r(i)=0.5*(THETA_r{i}(Peaks_r{i}(1,2))  +  THETA_r{i}(Peaks_r{i}(2,2))); % calculating average angel 
end 
%% calculating angel from 0
for i=1:16
    % left
    if Angles_l(i)>0
        Angles_l(i)=Angles_l(i)-43.5;
    end

    if Angles_l(i)<0
        Angles_l(i)=(90-43.5)+90+Angles_l(i);
    end
    %right
    if Angles_r(i)>0
        Angles_r(i)=Angles_r(i)-43.5;
    end

    if Angles_r(i)<0
        Angles_r(i)=(90-43.5)+90+Angles_r(i);
    end
end
%% calculate kN
Force_l=Angles_l.*(3/136.5); % in kN;
Force_r=Angles_r.*(3/136.5); % in kN;
disp(Angles_r-Angles_l)









    
