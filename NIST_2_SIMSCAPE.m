% User Section


fileNameNist = 'N2_properties_From_NIST.txt'; %define NIST file name
T = Nist_Table_Loader(fileNameNist);

T([9,10], :) = []; %remove some values if required

%%

TempVals = T{:,1};
PressVals = T{:,2};

% Get unique sorted parameter vectors
Temps = unique(TempVals);  % column vector
Press = unique(PressVals);  % column vector (will transpose for row vector)
n1 = numel(Temps);
n2 = numel(Press);

% Initialize containers
Temp_vec = Temps;
Press_vec = Press';  % row vector

% Loop through each dependent column
for k = 3:width(T)
    depName = T.Properties.VariableNames{k};
    depVals = T{:,k};

    % Create empty matrix
    M = NaN(n1, n2);

    % Fill matrix values according to (param1,param2)
    for i = 1:numel(TempVals)
        i1 = find(Temps == TempVals(i));
        i2 = find(Press == PressVals(i));
        M(i1, i2) = depVals(i);
    end

    % Assign to dynamic variable name (optional)
    assignin('base', ['M_' depName], M);

    % Or store in structure
    M_struct.(depName) = M;
end

M_IsothermalBulkModulusMpa = repmat(Press_vec, numel(Temps), 1);
M_IsobaricThermalExpansion1_K = repmat(1./Temp_vec, 1, numel(Press));

% Now you have:
% param1_vec  -> column vector of parameter 1
% param2_vec  -> row vector of parameter 2
% M_struct.depA, M_struct.depB, etc.
