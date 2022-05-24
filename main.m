function dataset = main(valueCategory, cityPicked, weightCriteria)
dataset = get_dataset();

% normalization price dataset
price1 = dataset.Price <= 10000;
dataset.PriceValue(price1) = 1;

price2 = dataset.Price > 10000 & dataset.Price <= 50000;
dataset.PriceValue(price2) = 2;

price3 = dataset.Price > 50000 & dataset.Price <= 100000;
dataset.PriceValue(price3) = 3;

price4 = dataset.Price > 100000;
dataset.PriceValue(price4) = 5;

% Replace Value Category

% valueCategory = ["Bahari" 10; "Budaya" 20; "Cagar Alam" 30; "Pusat Perbelanjaan" 25; "Taman Hiburan" 15; "Tempat Ibadah" 50];
for index = 1:length(valueCategory)
    name = string(valueCategory{index});
    value = string(valueCategory{index,2});
    value = str2double(value);
    
    dataset.CategoryValue(dataset.Category == name) = value;
end

% Filter City
% allCity = ["Yogyakarta" "Semarang" "Bandung" "Jakarta" "Surabaya"];
cityPicked = ismember(dataset.City, cityPicked);
dataset(not(cityPicked), :) = [];


datasetWP = [dataset.PriceValue dataset.Rating dataset.CategoryValue];

weightCriteria = weightCriteria ./ sum(weightCriteria);
typeCriteria = ["COST", "BENEFIT", "BENEFIT"];

[rowLength, columnLength] = size(datasetWP);


%tahapan kedua, melakukan perhitungan vektor(S) per baris (alternatif)
for j=1:columnLength
    if typeCriteria(j)== "COST"
        weightCriteria(j)= -1 * weightCriteria(j);
    end
end

vectorS = zeros(1, rowLength);
for i=1:rowLength
    vectorS(i) = prod(datasetWP(i,:) .^ weightCriteria);
end

%tahapan ketiga, proses perangkingan
vectorV = vectorS / sum(vectorS);
result = transpose(vectorV);

dataset.Result = result;
dataset = sortrows(dataset, 'Result', 'descend');
dataset = head(dataset, 10);
end
