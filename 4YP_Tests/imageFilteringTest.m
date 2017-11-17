% ImageFilteringTest


%% Don't Photoshop it...MATLAB it! Image Effects with MATLAB (Part 2)
%
% _I'd like to welcome back guest blogger
% <http://www.mathworks.com/matlabcentral/fileexchange/authors/911 Brett
% Shoelson> for the continuation of his series of posts on implementing
% image special effects in MATLAB. Brett, a contributor for the
% <http://blogs.mathworks.com/pick/ File Exchange Pick of the Week blog>,
% has been doing image processing with MATLAB for almost 20 years now._
%%
% 
% <<http://blogs.mathworks.com/pick/files/fluorescentzebra.png>>
% 
%% |imadjust| as an Image Enhancement Tool
% In my <http://blogs.mathworks.com/steve/?p=701 previous post> in this
% guest series, I introduced my
% <http://www.mathworks.com/matlabcentral/fileexchange/955-imadjustgui
% image adjustment GUI>, and used it to enhance colors in modified versions
% of images of a mandrill and of two zebras. For both of those images, I
% operated on all colorplanes uniformly; i.e., whatever I did to the red
% plane, I also did to green and blue. The calling syntax for |imadjust| is
% as follows:
%
%  imgOut = imadjust(imgIn,[low_in; high_in],[low_out; high_out],gamma);
%
% The default inputs are:
%
%  imgOut = imadjust(imgIn,[0; 1],[0; 1],1);
%
% Different input parameters will produce different effects. In fact,
% |imadjust| should often be the starting point for simply correcting
% illumination issues with an image:

  %URL = 'http://blogs.mathworks.com/pick/files/DrinkingZebra1.jpg';
  %img = imrotate(imread(URL,'jpg'),-90);
  img = imread('Sunset.jpg');
  enhanced = imadjust(img,[0.30; 0.85],[0.90; 0.00], 0.90);
  subplot(1,2,1);imshow(img);title('Original');
  subplot(1,2,2);imshow(enhanced);title('|imadjust|-Enhanced');

%%
% 
% <<http://blogs.mathworks.com/pick/files/imadjustDemo.png>>
% 

%%
% You may recall that when I modified the image of two zebras in my previous post, I not only
% increased low_out, but I also reversed (and tweaked) the values for
% low_out and high_out:
%
%  imgEnhanced = imadjust(imgEnhanced,[0.30; 0.85],[0.90; 0.00], 0.90);
% 
% In reversing those input values, I effectively _reversed the image_. In
% fact, for a grayscale image, calling
%
%   imgOut = imadjust(imgIn,[0; 1],[1; 0],1); % Note the reversal of low_out and high_out
%
% is equivalent to calling |imgOut = imcomplement(imgIn)|:
%
%   img = imread('cameraman.tif');
%   img1 = imadjust(img,[0.00; 1.00],[1.00; 0.00], 1.00);
%   img2 = imcomplement(img);
%   assert(isequal(img1,img2))% No error is thrown!
%   figure;subplot(1,2,1);imshow(img);xlabel('Original image courtesy MIT');
%   subplot(1,2,2);imshow(img1);
%%
% 
% <<http://blogs.mathworks.com/pick/files/cameramanReversed1.png>>
% 

%%
% Now recognize that ImadjustGUI calls |imadjust| behind the scenes, using
% the standard syntax. If you read the documentation for |imadjust|
% carefully, you will learn that the parameter inputs low_in, high_in,
% low_out, high_out, and gamma need not be scalars. In fact, if those
% parameters are specifed appropriately as 1-by-3 vectors, then |imadjust|
% operates _separately_ on the red, green, and blue colorplanes:
%
%%
%  newmap = imadjust(map,[low_in; high_in],[low_out; high_out],gamma)
%
%   % ...transforms the colormap associated with an indexed image.
%   % If low_in, high_in, low_out, high_out, and gamma are scalars, then the
%   % same mapping applies to red, green, and blue components.
%   %
%   % Unique mappings for each color component are possible when low_in and
%   % high_in are both 1-by-3 vectors, low_out and high_out are both 1-by-3 vectors, 
%   % or gamma is a 1-by-3 vector. 
%
% That works for adjusting colormaps; it also works for adjusting images.
% As a result, _you can readily reverse individual colorplanes_ of an input
% RGB image, and in doing, create some cool effects!

%% Andy Warhol Meets an Elephant
% Andy Warhol famously created iconic images of Marilyn Monroe and other
% celebrities, casting them in startling, unexpected colors, and sometimes
% tiling them to create memorable effects. We can easily produce similar
% effects by _reversing and saturating_ individual colorplanes of RGB
% images. (I wrote |ImadjustGUI| to facilitate, interactively, those
% plane-by-plane intensity adjustments.)

%% 
% 
% <<http://blogs.mathworks.com/pick/files/WarholElephants.png>>
% 

%% Reading and Pre-Processing the Elephant
% First, of course, we read and display the elephant:
%
%  URL = 'http://blogs.mathworks.com/pick/files/ElephantProfile.jpg';
%  img = imread(URL);
%
%% 
% He's a wrinkly old fellow (below left). I'd like to bring out those wrinkles by
% enhancing contrast in the image. There are a few ways to do that, but I
% learned about my favorite way by reading through
% the "Gray-Scale Morphology" section of 
% <http://imageprocessingplace.com/DIPUM-2E/dipum2e_main_page.htm DIPUM, 2nd Ed.>
% Specifically, the authors of this (most excellent) book indicated (on page 529) that
% one could combine topat and bottomhat filters to enhance contrast. (I
% built the appropriate combination of those filters behind the "Contrast Enhancement" 
% button of
% <http://www.mathworks.com/matlabcentral/fileexchange/23697-morphtool MorphTool>.)
% So, using MorphTool-generated code:
%
%   SE = strel('Disk',18);
%   imgEnhanced = imsubtract(imadd(img,imtophat(img,SE)),imbothat(img,SE));
%
%%
% 
% <<http://blogs.mathworks.com/pick/files/ElephantContrast.png>>
% 

%%
% Now, operating with |imadjust| plane by plane, reversing the red and blue
% planes, and modifying the gamma mapping, I can easily find my way to 
% several interesting effects. For instance:
% 
%   imgEnhanced1 = imadjust(imgEnhanced,[0.00 0.00 0.00; 1.00 0.38 0.40],[1.00 0.00 0.70; 0.20 1.00 0.40], [4.90 4.00 1.70]);
%   imgEnhanced2 = imadjust(imgEnhanced,[0.13 0.00 0.30; 0.75 1.00 1.00],[0.00 1.00 0.50; 1.00 0.00 0.27], [5.90 0.80 4.10]);
%
%%
% 
% <<http://blogs.mathworks.com/pick/files/SaturatedElephants.png>>
% 

%%
% So, two more of those interesting effects, and then we can compose the
% four-elephants image above:
%
%  imgEnhanced3 = imadjust(img,[0.20 0.00 0.09; 0.83 1.00 0.52],[0.00 0.00 1.00; 1.00 1.00 0.00], [1.10 2.70 1.00]);
%  imgEnhanced4 = imadjust(img,[0.20 0.00 0.00; 0.70 1.00 1.00],[1.00 0.90 0.00; 0.00 0.90 1.00], [1.30 1.00 1.00]);

%%
% I also wanted to flip two of those enhanced images. |fliplr| makes it
% easy to flip a 2-dimensional matrix, but it doesn't work on RGB
% images. So I flipped them plane-by-plane, and concatenated
% <http://www.mathworks.com/help/releases/R2012b/matlab/ref/cat.html |cat|> 
% the flipped planes in the third ( _z_ -) dimensioninto new RGB images:
%
%  r = fliplr(imgEnhanced2(:,:,1));
%  g = fliplr(imgEnhanced2(:,:,2));
%  b = fliplr(imgEnhanced2(:,:,3));
%  imgEnhanced2 = cat(3,r,g,b);
% 
%   CompositeImage = [imgEnhanced1 imgEnhanced2; imgEnhanced3 imgEnhanced4]; % (Images 2 and 4 are flipped plane-by-plane.)
 
%% Next Up: Put Me In the Zoo!
%%
% 
% <<http://blogs.mathworks.com/pick/files/GiraffeSpots.png>>
% 
%%
% All images except "cameraman" copyright Brett Shoelson; used with permission.


%%
% _Copyright 2012 The MathWorks, Inc._