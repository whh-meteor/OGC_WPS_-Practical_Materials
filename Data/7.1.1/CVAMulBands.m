function c = CVAMulBands(iA,iB,res)

InputTIFImageA = importdata(iA);
InputTIFImageB = importdata(iB);
%Info=imfinfo(iB)
[I,R] = geotiffread(iA);
info = geotiffinfo(iA);
disp(info)
A1= InputTIFImageA(:,:,1);%��ȡ��1������
A2= InputTIFImageA(:,:,2);%��ȡ��2������
A3= InputTIFImageA(:,:,3);%��ȡ��3������
A4= InputTIFImageA(:,:,4);%��ȡ��4������
A5= InputTIFImageA(:,:,5);%��ȡ��5������
A6= InputTIFImageA(:,:,6);%��ȡ��6������


B1= InputTIFImageB(:,:,1);%��ȡ��1������
B2= InputTIFImageB(:,:,2);%��ȡ��2������
B3= InputTIFImageB(:,:,3);%��ȡ��3������
B4= InputTIFImageB(:,:,4);%��ȡ��4������
B5= InputTIFImageB(:,:,5);%��ȡ��5������
B6= InputTIFImageB(:,:,6);%��ȡ��6������


A1=double(A1);A2=double(A2);A3=double(A3);A4=double(A4);A5=double(A5);A6=double(A6);
B1=double(B1);B2 =double(B2);B3 =double(B3);B4 =double(B4);B5 =double(B5);B6=double(B6);
C=sqrt((B1-A1).^2+(B2-A2).^2+(B3-A3).^2+(B4-A4).^2+(B5-A5).^2+(B6-A6).^2);
disp(C)
 amax = max(max(C));   
amin = min(min(C));  
a1=255*(C-amin)/(amax-amin); 
a1=uint8(a1);
%imshow(a1);
%����ͼ��
%CM=KmeansMap(a1,400,400);

%testImage=CM;
%changeImage=CM;
%changeImage(find(changeImage==1))=255;

%filename1 = 'changecva.tif';

%geotiffwrite(filename1, changeImage,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);


outraster = a1;

filename = res;
geotiffwrite(filename, outraster,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
c=1;
end



