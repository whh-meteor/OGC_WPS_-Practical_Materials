function  testImage =PCAMulbands(iA,iB,res)

%iA='bb.tif'
%iB='aa.tif'
%A ǰ�� B ����
InputTIFImageA = importdata(iA);
InputTIFImageB = importdata(iB);

[I,R] = geotiffread(iA);
info = geotiffinfo(iA);
 
%��ȡ��һ��Ӱ��ĳ��� ����
sizea=size(InputTIFImageA);
disp(sizea(1))
%��ȡA�Ĳ�����
bands = sizea(3);

%����ת��
if(bands<=3)
    
     A1= InputTIFImageA(:,:,1);%��ȡ��i������
A2= InputTIFImageA(:,:,2);%��ȡ��j������
A3= InputTIFImageA(:,:,3);%��ȡ��k������

B1= InputTIFImageB(:,:,1);%��ȡ��i������
B2= InputTIFImageB(:,:,2);%��ȡ��j������
B3= InputTIFImageB(:,:,3);%��ȡ��k������

 A1=double(A1);A2=double(A2);A3=double(A3);
 B1=double(B1);B2 =double(B2);B3 =double(B3);

else 
    %��ȡ����
A1= InputTIFImageA(:,:,1);%��ȡ��i������
A2= InputTIFImageA(:,:,2);%��ȡ��j������
A3= InputTIFImageA(:,:,3);%��ȡ��k������
A4= InputTIFImageA(:,:,4);%��ȡ��k������
A5= InputTIFImageA(:,:,5);%��ȡ��k������
A6= InputTIFImageA(:,:,6);%��ȡ��k������

B1= InputTIFImageB(:,:,1);%��ȡ��i������
B2= InputTIFImageB(:,:,2);%��ȡ��j������
B3= InputTIFImageB(:,:,3);%��ȡ��k������
B4= InputTIFImageB(:,:,4);%��ȡ��k������
B5= InputTIFImageB(:,:,5);%��ȡ��k������
B6= InputTIFImageB(:,:,6);%��ȡ��k������

if(bands>=7)
    A7= InputTIFImageA(:,:,7);%��ȡ��k������
    B7= InputTIFImageB(:,:,7);%��ȡ��k������
     A7=double(A7);
     B7=double(B7);
end
if(bands>=8)
    A8= InputTIFImageA(:,:,8);%��ȡ��k������
    B8= InputTIFImageB(:,:,8);%��ȡ��k������
     A8=double(A8);
     B8=double(B8);
end
    A1=double(A1);A2=double(A2);A3=double(A3);A4=double(A4);A5=double(A5);A6=double(A6);
    B1=double(B1);B2 =double(B2);B3 =double(B3);B4 =double(B4);B5 =double(B5);B6=double(B6);

end
if(bands<=3)
    Diff_V1=sqrt((B1-A1).^2);
Diff_V2=sqrt((B2-A2).^2);
Diff_V3=sqrt((B3-A3).^2);

%ͼ��չƽ 160000*1
d1=reshape(Diff_V1,sizea(1)*sizea(2),1);
d2=reshape(Diff_V2,sizea(1)*sizea(2),1);
d3=reshape(Diff_V3,sizea(1)*sizea(2),1);

%�ϲ� w=160000*6
w=[];
w(:,1)=d1;
w(:,2)=d2;
w(:,3)=d3;
else
    %����
Diff_V1=sqrt((B1-A1).^2);
Diff_V2=sqrt((B2-A2).^2);
Diff_V3=sqrt((B3-A3).^2);
Diff_V4=sqrt((B4-A4).^2);
Diff_V5=sqrt((B5-A5).^2);
Diff_V6=sqrt((B6-A6).^2);
if(bands>=7)
    Diff_V7=sqrt((B7-A7).^2);
end
if(bands>=8)
    Diff_V8=sqrt((B8-A8).^2);
end


%ͼ��չƽ 160000*1
d1=reshape(Diff_V1,sizea(1)*sizea(2),1);
d2=reshape(Diff_V2,sizea(1)*sizea(2),1);
d3=reshape(Diff_V3,sizea(1)*sizea(2),1);
d4=reshape(Diff_V4,sizea(1)*sizea(2),1);
d5=reshape(Diff_V5,sizea(1)*sizea(2),1);
d6=reshape(Diff_V6,sizea(1)*sizea(2),1);
if(bands>=7)
    d7=reshape(Diff_V7,sizea(1)*sizea(2),1);
end
if(bands>=8)
    d8=reshape(Diff_V8,sizea(1)*sizea(2),1);
end


%�ϲ� w=160000*6
w=[];
w(:,1)=d1;
w(:,2)=d2;
w(:,3)=d3;
w(:,4)=d4;
w(:,5)=d5;
w(:,6)=d6;
if(bands>=7)
    w(:,7)=d7;
end
if(bands>=8)
    w(:,8)=d8;
end
end

%��ֵ
A=w;

%PCA��ά A : 160000*6 ->160000*2
 [A,T,meanValue,test] = PCA(A,0.75);
 %��ȡЧ���õ�һ������
 pio=A(:,1);
 %ͼ��ָ�Ϊ��*��
 Are=reshape( pio,info.Height,info.Width);
Are=uint8(Are);
%��ʾ����ͽ��ͼ��
%imshow(Are)

%����ͼ��
    %չƽ��ά2���� ���о��� 
%      KMin = reshape(Are,info.Height*info.Width,1)
%CM=KmeansMap(KMin,info.Height,info.Width);
%CMת�� ��ͼ��ָ�����
%CM=CM';
%����仯ǿ��
outraster=Are;
%�����ֵ����ͼ
%changeImage=CM;
%���¸�ֵ
%changeImage(find(changeImage==1))=255;
%filename = 'ins.tif';
%filename1 = 'change.tif';
testImage=1;
geotiffwrite(res, outraster,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
%geotiffwrite(filename1, changeImage,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
end



function [DimRedu_X,T,meanValue,X] = PCA(X,CRate)
%--newX  ��ά����¾���   --T �任����  --meanValue  Xÿ�о�ֵ���ɵľ������ڽ���ά��ľ���newX�ָ���X  --CRate ������

%PCA�����ɷַ������㷨����Ҫ�������ݽ�ά�����������ݼ��жԷ�����������ɸ��������ﵽ�����ݼ���Ŀ�ġ�
%ʵ�����ݽ�ά�Ĳ��裺
%1����ԭʼ�����е�ÿһ��������������ʾ�����������������������һ������ͨ���������������д����õ����Ļ���������
% 2�������������Э�������
% 3����Э������������ֵ����������
% 4�������������������������ֵ�Ĵ�С��������γ�һ��ӳ����󡣲�����ָ����PCA��������������ȡ��ӳ������ǰn�л���ǰn����Ϊ���յ�ӳ�����
% 5����ӳ���������ݽ���ӳ�䣬�ﵽ���ݽ�ά��Ŀ�ġ�
% ���Ļ������������������������Ļ�����ÿһά�ȼ�ȥ��ά�ȵľ�ֵ

%�������Ļ�

meanValue=ones(size(X,1),1)*mean(X);
X=X-meanValue;%ÿ��ά�ȼ�ȥ��ά�ȵľ�ֵ

%����Э����
 C=X'*X/(size(X,1)-1); %C=cov(X);%����Э�������

%������������������ֵ
[V,D]=eig(C);

%������ֵ��������
% ��Ϊsort�������������У�����Ҫ���ǽ������У�������ȡ����,diag(a)��ȡ��a�ĶԽ�Ԫ�ع���
% һ���������������dummy�ǽ������к��������order��������˳��
[~,order]=sort(diag(-D));
V=V(:,order);%������������������ֵ��С���н�������
D=diag(D);%������ֵȡ��������һ��������
D=D(order);%������ֵ���ɵ�����������������


%ȡǰn���������������ɱ任����
sumd=sum(D);%����ֵ֮��
for j=1:length(D)
    i=sum(D(1:j,1))/sumd;%���㹱���ʣ�������=ǰn������ֵ֮��/������ֵ֮��
    if i>CRate%�������ʴ���95%ʱѭ������,������ȡ���ٸ�����ֵ
       cols=j;
       break;
    end
end
T=V(:,1:cols);%ȡǰcols���������������ɱ任����T

DimRedu_X=X*T;%�ñ任����T��X���н�ά

%��ԭX
X=DimRedu_X*T'+meanValue;
end