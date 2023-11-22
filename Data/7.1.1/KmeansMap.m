function CM = KmeansMap(ChangeIntensity_Image,res)
%K-MEANSMAP ����仯ǿ�Ƚ���k-means���� Ȼ�󷵻ض�ֵͼMap 0��unchage   1��change 
% @date 2016-11-01
% @author WangYong

[I,R] = geotiffread(ChangeIntensity_Image);
info = geotiffinfo(ChangeIntensity_Image);
InputTIFImageA = importdata(ChangeIntensity_Image);
imshow(InputTIFImageA)
[H,W]=size(InputTIFImageA);

ChangeIntensity_Image=reshape(InputTIFImageA,H*W,1);
%K-means����2�� 1000�ε���
ChangeIntensity_Image=double(ChangeIntensity_Image);
index = kmeans(ChangeIntensity_Image, 2, 'EmptyAction', 'singleton','Maxiter',1500);
disp(size(index));
CM = zeros(H,W);
k = 1;
for i = 1:H
    for j = 1:W
        CM(i,j) = index(k) - 1;
        k = k + 1;
    end
end
indx_1 = find(CM == 1); %�仯����
indx_0 = find(CM == 0); %��������


%�������������������ľ�ֵС�ڱ仯����CM()=1???
mean_1 = mean(ChangeIntensity_Image(indx_1));
mean_0 = mean(ChangeIntensity_Image(indx_0));
if(mean_0<mean_1)
    disp('�仯����Ե� 1��');
    CM(indx_0) = 0;
    CM(indx_1) = 1;
else
    CM(indx_0) = 1;
    CM(indx_1) = 0;
    disp('�仯����Ե� 0��');
end
%imshow(CM);
CM=CM';
geotiffwrite(res, CM,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
end
