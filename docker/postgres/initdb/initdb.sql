CREATE TABLE daily_delhi_climate_train (
  date date, 
  meantemp numeric(20,15), 
  humidity numeric(20,15), 
  wind_speed numeric(20,15), 
  meanpressure numeric(20,15)
);

COPY daily_delhi_climate_train 
FROM '/docker-entrypoint-initdb.d/DailyDelhiClimateTrain.csv' 
DELIMITER ',' -- Specify comma as the field delimiter
CSV HEADER; -- Indicate that the first row of the CSV contains column headers