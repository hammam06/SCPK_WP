function dataset = get_dataset()
dataset = readtable('tourism_with_id.csv');
dataset = removevars(dataset,["Time_Minutes" "Coordinate", "Lat", "Long", "Var12", "Var13"]);
end