[Itemp,aHeader]= readgeoraster('../data/dataKokkola/kokkolaDEM21-10-2020.tif','Bands',1);
disp('Kokkola read done')
zPerimeterA= 30.0; % (m)
I= (Itemp == -32767)*zPerimeterA + (Itemp ~= -32767) .*Itemp;
mask= (Itemp == -32767)*0 + (Itemp ~= -32767)*1;
z1a= 33.0; % (m) min(min(I));
z2a= 44.0; % (m) max(max(I)); 
disp('Kokkola mask done')
figure(1); subplot(2,2,1);
    imshow(I); caxis([z1a,z2a]); colorbar; title('Kokkola');
subplot(2,2,2);
    m= reshape(mask,prod(size(mask)),1); inds= find(m);
    z= reshape(I,prod(size(I)),1); z= z(inds);
    hist(z,40);
    xlabel('z (m)'); title('Kokkola');

z= I; save('../data/z1.mat','z','mask'); clear z;

zPerimeterB= 102.0; % (m)
[Itemp,bHeader]= readgeoraster('../data/dataSievi/elevation.tif','Bands',1);
disp('Sievi read done')
I= (Itemp == -32767)*zPerimeterB + (Itemp ~= -32767) .*Itemp;
mask= (Itemp == -32767)*0 + (Itemp ~= -32767)*1;
z1b= 108.0; % (m) max(max(I)); 
z2b= 117.0; % (m) min(min(I));
disp('Sievi mask done')
subplot(2,2,3);
    imshow(I); caxis([z1b,z2b]); colorbar; title('Sievi');

subplot(2,2,4);
    m= reshape(mask,prod(size(mask)),1); inds= find(m);
    z= reshape(I,prod(size(I)),1); z= z(inds);
    hist(z,40);
    xlabel('z (m)'); title('Sievi');

z= I; save('../data/z2.mat','z','mask'); clear z;

disp('done!')
