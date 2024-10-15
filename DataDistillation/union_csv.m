%combine test files in Blog dataset in one cvs file
ì
folderPath = "\Datasets\blogfeedback\test_files";
csvFiles = dir(folderPath);
csvFiles = {csvFiles.name};
csvFiles = csvFiles(cellfun(@(f) contains(f,'.csv'),csvFiles));
combinedData = table();
%fileNames{f}
for k = 1:length(csvFiles)
    fileName = fullfile(folderPath, csvFiles{k});
    data = readtable(fileName);
    combinedData = [combinedData; data];
end
outputFileName = fullfile(folderPath, 'combined_data.csv');
writetable(combinedData, outputFileName);


    