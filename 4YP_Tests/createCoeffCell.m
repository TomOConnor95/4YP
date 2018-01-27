function coeffCell = createCoeffCell(coeff)
%Puts the PCA coefficients in a cell structure to match the presetStore
%cell structure
coeffCell = cell(1,12);

coeffCell{1} = coeff(1:36,1:8);
coeffCell{2} = coeff(37:42,1:8);
coeffCell{3} = coeff(43:48,1:8);
coeffCell{4} = coeff(49:54,1:8);
coeffCell{5} = coeff(55:60,1:8);
coeffCell{6} = coeff(61:66,1:8);
coeffCell{7} = coeff(67:72,1:8);
coeffCell{8} = coeff(73:75,1:8);
coeffCell{9} = coeff(76:78,1:8);
coeffCell{10} = coeff(79:83,1:8);
coeffCell{11} = coeff(84:88,1:8);
coeffCell{12} = coeff(89:94,1:8);
end