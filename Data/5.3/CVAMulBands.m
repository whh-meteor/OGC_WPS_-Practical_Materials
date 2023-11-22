function c = CVAMulBands(iA,iB,res)

InputTIFImageA = importdata(iA);
InputTIFImageB = importdata(iB);

[I,R] = geotiffread(iA);
info = geotiffinfo(iA);
disp(info)
A1= InputTIFImageA(:,:,1);%获取第1个波段
A2= InputTIFImageA(:,:,2);%获取第2个波段
A3= InputTIFImageA(:,:,3);%获取第3个波段
A4= InputTIFImageA(:,:,4);%获取第4个波段
A5= InputTIFImageA(:,:,5);%获取第5个波段
A6= InputTIFImageA(:,:,6);%获取第6个波段

B1= InputTIFImageB(:,:,1);%获取第1个波段
B2= InputTIFImageB(:,:,2);%获取第2个波段
B3= InputTIFImageB(:,:,3);%获取第3个波段
B4= InputTIFImageB(:,:,4);%获取第4个波段
B5= InputTIFImageB(:,:,5);%获取第5个波段
B6= InputTIFImageB(:,:,6);%获取第6个波段

A1=double(A1);A2=double(A2);A3=double(A3);A4=double(A4);A5=double(A5);A6=double(A6);
B1=double(B1);B2 =double(B2);B3 =double(B3);B4 =double(B4);B5 =double(B5);B6=double(B6);
C=sqrt((B1-A1).^2+(B2-A2).^2+(B3-A3).^2+(B4-A4).^2+(B5-A5).^2+(B6-A6).^2);
disp(C)
 amax = max(max(C));   
amin = min(min(C));  
a1=255*(C-amin)/(amax-amin); 
a1=uint8(a1);
%保存图像
outraster = a1;
filename = res;
geotiffwrite(filename, outraster,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
c=1;
end