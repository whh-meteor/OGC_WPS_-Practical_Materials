function  testImage =PCAMulbands(iA,iB,res)

%iA='bb.tif'
%iB='aa.tif'
%A 前序 B 后序
InputTIFImageA = importdata(iA);
InputTIFImageB = importdata(iB);

[I,R] = geotiffread(iA);
info = geotiffinfo(iA);
 
%获取第一期影像的长宽 波段
sizea=size(InputTIFImageA);
disp(sizea(1))
%获取A的波段数
bands = sizea(3);

%类型转换
if(bands<=3)
    
     A1= InputTIFImageA(:,:,1);%获取第i个波段
A2= InputTIFImageA(:,:,2);%获取第j个波段
A3= InputTIFImageA(:,:,3);%获取第k个波段

B1= InputTIFImageB(:,:,1);%获取第i个波段
B2= InputTIFImageB(:,:,2);%获取第j个波段
B3= InputTIFImageB(:,:,3);%获取第k个波段

 A1=double(A1);A2=double(A2);A3=double(A3);
 B1=double(B1);B2 =double(B2);B3 =double(B3);

else 
    %读取波段
A1= InputTIFImageA(:,:,1);%获取第i个波段
A2= InputTIFImageA(:,:,2);%获取第j个波段
A3= InputTIFImageA(:,:,3);%获取第k个波段
A4= InputTIFImageA(:,:,4);%获取第k个波段
A5= InputTIFImageA(:,:,5);%获取第k个波段
A6= InputTIFImageA(:,:,6);%获取第k个波段

B1= InputTIFImageB(:,:,1);%获取第i个波段
B2= InputTIFImageB(:,:,2);%获取第j个波段
B3= InputTIFImageB(:,:,3);%获取第k个波段
B4= InputTIFImageB(:,:,4);%获取第k个波段
B5= InputTIFImageB(:,:,5);%获取第k个波段
B6= InputTIFImageB(:,:,6);%获取第k个波段

if(bands>=7)
    A7= InputTIFImageA(:,:,7);%获取第k个波段
    B7= InputTIFImageB(:,:,7);%获取第k个波段
     A7=double(A7);
     B7=double(B7);
end
if(bands>=8)
    A8= InputTIFImageA(:,:,8);%获取第k个波段
    B8= InputTIFImageB(:,:,8);%获取第k个波段
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

%图像展平 160000*1
d1=reshape(Diff_V1,sizea(1)*sizea(2),1);
d2=reshape(Diff_V2,sizea(1)*sizea(2),1);
d3=reshape(Diff_V3,sizea(1)*sizea(2),1);

%合并 w=160000*6
w=[];
w(:,1)=d1;
w(:,2)=d2;
w(:,3)=d3;
else
    %计算
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


%图像展平 160000*1
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


%合并 w=160000*6
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

%赋值
A=w;

%PCA降维 A : 160000*6 ->160000*2
 [A,T,meanValue,test] = PCA(A,0.75);
 %获取效果好的一个波段
 pio=A(:,1);
 %图像恢复为长*宽
 Are=reshape( pio,info.Height,info.Width);
Are=uint8(Are);
%显示输入和结果图像
%imshow(Are)

%保存图像
    %展平降维2波段 进行聚类 
%      KMin = reshape(Are,info.Height*info.Width,1)
%CM=KmeansMap(KMin,info.Height,info.Width);
%CM转置 让图像恢复正常
%CM=CM';
%输出变化强度
outraster=Are;
%输出二值分类图
%changeImage=CM;
%重新赋值
%changeImage(find(changeImage==1))=255;
%filename = 'ins.tif';
%filename1 = 'change.tif';
testImage=1;
geotiffwrite(res, outraster,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
%geotiffwrite(filename1, changeImage,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
end



function [DimRedu_X,T,meanValue,X] = PCA(X,CRate)
%--newX  降维后的新矩阵   --T 变换矩阵  --meanValue  X每列均值构成的矩阵，用于将降维后的矩阵newX恢复成X  --CRate 贡献率

%PCA（主成分分析）算法，主要用于数据降维，保留了数据集中对方差贡献最大的若干个特征来达到简化数据集的目的。
%实现数据降维的步骤：
%1、将原始数据中的每一个样本用向量表示，把所有样本组合起来构成一个矩阵，通常需对样本矩阵进行处理，得到中心化样本矩阵
% 2、求样本矩阵的协方差矩阵
% 3、求协方差矩阵的特征值和特征向量
% 4、将求出的特征向量按照特征值的大小进行组合形成一个映射矩阵。并根据指定的PCA保留的特征个数取出映射矩阵的前n行或者前n列作为最终的映射矩阵。
% 5、用映射矩阵对数据进行映射，达到数据降维的目的。
% 中心化样本矩阵：先让样本矩阵中心化，即每一维度减去该维度的均值

%样本中心化

meanValue=ones(size(X,1),1)*mean(X);
X=X-meanValue;%每个维度减去该维度的均值

%矩阵协方差
 C=X'*X/(size(X,1)-1); %C=cov(X);%计算协方差矩阵

%计算特征向量，特征值
[V,D]=eig(C);

%将特征值降序排序
% 因为sort函数是升序排列，而需要的是降序排列，所以先取负号,diag(a)是取出a的对角元素构成
% 一个列向量，这里的dummy是降序排列后的向量，order是其排列顺序
[~,order]=sort(diag(-D));
V=V(:,order);%将特征向量按照特征值大小进行降序排列
D=diag(D);%将特征值取出，构成一个列向量
D=D(order);%将特征值构成的列向量按降序排列


%取前n个特征向量，构成变换矩阵
sumd=sum(D);%特征值之和
for j=1:length(D)
    i=sum(D(1:j,1))/sumd;%计算贡献率，贡献率=前n个特征值之和/总特征值之和
    if i>CRate%当贡献率大于95%时循环结束,并记下取多少个特征值
       cols=j;
       break;
    end
end
T=V(:,1:cols);%取前cols个特征向量，构成变换矩阵T

DimRedu_X=X*T;%用变换矩阵T对X进行降维

%还原X
X=DimRedu_X*T'+meanValue;
end