%script for converting imported image matrix into signal vector

load cameraman.mat
img=i; %renamed imported variable because it interfered with indexing variable "i"
clear("i");
y=img(:);
y=(y-128)/128;
