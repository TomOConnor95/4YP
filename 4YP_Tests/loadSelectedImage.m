function [imgFullSize] = loadSelectedImage(selectedImageNumber)

switch selectedImageNumber
    case 1, imgFullSize = imread('Sunset.jpg');
    case 2, imgFullSize = imread('Sunset2.jpg');
    case 3, imgFullSize = imread('Sea.jpg');
    case 4, imgFullSize = imread('Venice.jpg');
    case 5, imgFullSize = imread('Gig.jpg');
    case 6, imgFullSize = imread('Bee.jpg');
    case 7, imgFullSize = imread('Leaves.jpeg');
    case 8, imgFullSize = imread('MaddieSea.jpg');    
    case 9, imgFullSize = imread('FaceFace.jpg');       
    otherwise
            error('Invalid Image Number')
end
