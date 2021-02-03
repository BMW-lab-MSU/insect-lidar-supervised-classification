for i = 1:length(adjusted_data_decembercal)
    A = adjusted_data_decembercal(i).normalized_data;
    %% Subtract Mean Column from each column - Absolute Value
    Afin = A - repmat(mean(A,2),1,size(A,2));
    yfit(i) = cosineKNN.predictFcn(Afin);
end