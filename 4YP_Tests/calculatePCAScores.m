function [x, y, R, G, B] = calculatePCAScores(appData, preset)
% Appdata is a ApplicatinoDataPCAInterface Class
alteredPresetFlattened = cell2mat(preset);
    mu = mean(cell2mat(appData.presetStoreVaried));
    alteredPresetFlattened = alteredPresetFlattened - mu;

    idxMax = max([appData.idxX, appData.idxY, appData.idxR, appData.idxG, appData.idxB]);
    testScore = alteredPresetFlattened*appData.coeff(:,1:idxMax);

    idxX = appData.idxX; 
    idxY = appData.idxY; 
    idxR = appData.idxR;
    idxG = appData.idxG;
    idxB = appData.idxB;

    if appData.normaliseHistogram == true
        % Need to apply the same historam normalisation to the new positition
        testScore(idxX) = newPointHistogramNormalisation(...
            testScore(idxX),appData.histParams.nX, appData.histParams.edgesX, appData.histBlend);

        testScore(idxY) = newPointHistogramNormalisation(...
            testScore(idxY),appData.histParams.nY, appData.histParams.edgesY, appData.histBlend);

        testScore(idxR) = newPointHistogramNormalisation(...
            testScore(idxR),appData.histParams.nR, appData.histParams.edgesR, appData.histBlend);

        testScore(idxG) = newPointHistogramNormalisation(...
            testScore(idxG),appData.histParams.nG, appData.histParams.edgesG, appData.histBlend);

        testScore(idxB) = newPointHistogramNormalisation(...
            testScore(idxB),appData.histParams.nB, appData.histParams.edgesB, appData.histBlend);
    end
        % Maybe should store the minimum and maximum value to avoid recalculation
        
        
        x = mapRange(testScore(idxX), appData.minX, appData.maxX, 0.05, 0.95);
        y = mapRange(testScore(idxY), appData.minY, appData.maxY, 0.05, 0.95);
        R = bound(mapRange(testScore(idxR), appData.minR, appData.maxR, 0.1, 1), 0, 1);
        G = bound(mapRange(testScore(idxG), appData.minG, appData.maxG, 0.1, 1), 0, 1);
        B = bound(mapRange(testScore(idxB), appData.minB, appData.maxB, 0.1, 1), 0, 1);
end
        
function [score] = newPointHistogramNormalisation(scoreIn, n, edges, histBlend)
    lowerEdgeIdx = find(edges < scoreIn, 1, 'last' );
    
    if isempty(lowerEdgeIdx)
        score = 0;
    else
        if lowerEdgeIdx == 0
        lowerSum = 0;
        else
            lowerSum = sum(n(1:lowerEdgeIdx-1));
        end

        if lowerEdgeIdx == length(edges)
            %disp('Out of range')
            score = mapRange(scoreIn,...
                        edges(lowerEdgeIdx), edges(lowerEdgeIdx)*1.1,...
                        lowerSum, lowerSum*1.1);
        else
        score = mapRange(scoreIn,...
                        edges(lowerEdgeIdx), edges(lowerEdgeIdx + 1),...
                        lowerSum, lowerSum + n(lowerEdgeIdx));
        end
    end
    score = histBlend*score + (1-histBlend)*scoreIn;
end
