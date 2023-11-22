function Reduction = Reduction(Aurl,Burl,res)

A=imread(Aurl);
[B,~] = geotiffread(Burl);
[m1,n1]=size(A);
[m2,n2]=size(B);
if m1~=m2 || n1~=n2
     m=max(m1,m2);
     n=max(n1,n2);
     maxi1 = zeros([m,n]);
     maxi2 = zeros([m,n]);
     
     maxi1(1:m1,1:n1) = A;
     maxi2(1:m2,1:n2) = B;
     
     A = maxi1;
     B = maxi2;
end



info = geotiffinfo(Burl);
disp(info.SpatialRef)
 R=info.SpatialRef;
A=double(A);
B=double(B);
t=abs(B-A);
[m,n]=size(t);
for i=1:m
for j=1:n
if t(i,j)>0
t(i,j)=255;
else 
t(i,j)=0;
end
end
end

outraster = t;
%imagesc(outraster);

filename =res;
R.RasterSize=([m,n]);
disp(R.RasterSize)
 disp(info.GeoTIFFTags.GeoKeyDirectoryTag);
geotiffwrite(filename, outraster,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);


Reduction=1;
end

