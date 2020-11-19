%script for converting signal vector to image matrix and printing result

yq=128*yq+128;
yq_=reshape(yq,256,256);
imshow(uint8(yq_));
