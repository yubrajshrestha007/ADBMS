-- Table to store spatial locations in Kathmandu
CREATE TABLE KathmanduPlaces (
    PlaceID INT PRIMARY KEY,
    PlaceName NVARCHAR(100),
    Location GEOGRAPHY
);
-- Insert some landmark coordinates using GEOGRAPHY::Point(latitude, longitude, SRID)
INSERT INTO KathmanduPlaces (PlaceID, PlaceName, Location)
VALUES
    (1, N'Swayambhunath Stupa', GEOGRAPHY::Point(27.7146, 85.2907, 4326)),
    (2, N'Boudhanath Stupa', GEOGRAPHY::Point(27.7211, 85.3619, 4326)),
    (3, N'Pashupatinath Temple', GEOGRAPHY::Point(27.7100, 85.3489, 4326)),
    (4, N'Durbar Square', GEOGRAPHY::Point(27.7049, 85.3076, 4326));


-- Define the reference location (Swayambhunath Stupa)
DECLARE @centerPoint GEOGRAPHY = GEOGRAPHY::Point(27.7146, 85.2907, 4326);

-- Find all places within 5 kilometers of Swayambhunath
SELECT PlaceName
FROM KathmanduPlaces
WHERE Location.STDistance(@centerPoint) <= 5000; -- 5000 meters = 5 km


-- Define current location (e.g., from GPS or user input)
DECLARE @currentLocation GEOGRAPHY = GEOGRAPHY::Point(27.6892, 85.3467, 4326);

-- Return the closest location
SELECT TOP 1
    PlaceName,
    Location.STDistance(@currentLocation) AS DistanceInMeters
FROM KathmanduPlaces
ORDER BY Location.STDistance(@currentLocation);
