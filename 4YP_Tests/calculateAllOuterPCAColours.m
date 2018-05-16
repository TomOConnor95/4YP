function colours = calculateAllOuterPCAColours(appData, presetA, presetB, presetC)
            % appData is a ApplicationDataBlendingInterface object which
            % contains an ApplicationDataPCAInterface object

            % relevant geometry ratios
            A1 = appData.G.ratios.A1;
            A2 = appData.G.ratios.A2;
            B1 = appData.G.ratios.B1;
            B2 = appData.G.ratios.B2;
            C1 = appData.G.ratios.C1;
            C2 = appData.G.ratios.C2;
            AB = appData.G.ratios.AB;
            BC = appData.G.ratios.BC;
            CA = appData.G.ratios.CA;
            
            presetA1 = mixPresets2(appData, A1, presetA, presetB, presetC);
            presetA2 = mixPresets2(appData, A2, presetA, presetB, presetC);
            presetB1 = mixPresets2(appData, B1, presetA, presetB, presetC);
            presetB2 = mixPresets2(appData, B2, presetA, presetB, presetC);
            presetC1 = mixPresets2(appData, C1, presetA, presetB, presetC);
            presetC2 = mixPresets2(appData, C2, presetA, presetB, presetC);
            
            presetAB = mixPresets2(appData, AB, presetA, presetB, presetC);
            presetBC = mixPresets2(appData, BC, presetA, presetB, presetC);
            presetCA = mixPresets2(appData, CA, presetA, presetB, presetC);
            
            [~,  ~, c.A1(1), c.A1(2), c.A1(3)] = calculatePCAScores(appData.pcaAppData, presetA1);
            [~,  ~, c.A2(1), c.A2(2), c.A2(3)] = calculatePCAScores(appData.pcaAppData, presetA2);
            [~,  ~, c.B1(1), c.B1(2), c.B1(3)] = calculatePCAScores(appData.pcaAppData, presetB1);
            [~,  ~, c.B2(1), c.B2(2), c.B2(3)] = calculatePCAScores(appData.pcaAppData, presetB2);
            [~,  ~, c.C1(1), c.C1(2), c.C1(3)] = calculatePCAScores(appData.pcaAppData, presetC1);
            [~,  ~, c.C2(1), c.C2(2), c.C2(3)] = calculatePCAScores(appData.pcaAppData, presetC2);
            
            [~,  ~, c.AB(1), c.AB(2), c.AB(3)] = calculatePCAScores(appData.pcaAppData, presetAB);
            [~,  ~, c.BC(1), c.BC(2), c.BC(3)] = calculatePCAScores(appData.pcaAppData, presetBC);
            [~,  ~, c.CA(1), c.CA(2), c.CA(3)] = calculatePCAScores(appData.pcaAppData, presetCA);
            
            colours = c;
        end