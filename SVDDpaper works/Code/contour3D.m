function [ output_args ] = contour3D( x,y,z,w,mu)
% x,y,z is all vector, w is a length(x)*length(y)*length(z) 3D matrix
if nargin == 4
    mu = -1;
end
n1 = length(x);
n2 = length(y);
n3 = length(z);
delta = 0.001;
count = 1;
 x1=[];
 y1=[];
 z1=[];
for i = 1:n1
    for j = 1:n2
        for k = 1:n3
            if w(i,j,k)<(mu+delta) && w(i,j,k)>(mu-delta)
                x1(count) = x(i);
                y1(count) = y(j);
                z1(count) = z(k);
                count = count + 1;
            end
        end
    end
end
%plot3(x1,y1,z1,'k*');hold on;
%Z=griddata(x1,y1,z1,X,Y);
%mesh(X,Y,Z)
%[x1,y1]=meshgrid(linspace(min(x1),max(x1),100),linspace(min(y1),max(y1),100));
%z1=griddata(x1,y1,z1,x1,y1,'v4');
%surf(x1,y1,z1);hold on;
if ~isempty(x1) && ~isempty(y1)
    [X,Y]=meshgrid(linspace(min(x1),max(x1),100),linspace(min(y1),max(y1),100));
    Z=griddata(x1,y1,z1,X,Y,'v4');
    mesh(X,Y,Z);hold on;
    box on;
end
end


