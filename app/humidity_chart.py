import sys
import psycopg2
import matplotlib.pyplot as plt

# Connect to your PostgreSQL database
# This block establishes a connection to the PostgreSQL database with specified credentials
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="postgres",
    host="postgresdb",  # Hostname should match the Docker container's hostname
    port="5432"         # Default port for PostgreSQL
)

# Create a cursor object
# The cursor allows interaction with the database to execute SQL queries
cur = conn.cursor()

# Define and execute the SQL query
# This query groups the data by year and finds the max and min humidity for each year
query = """
SELECT date_trunc('year', date) AS year, max(humidity), min(humidity) 
FROM daily_delhi_climate_train 
GROUP BY year
"""
cur.execute(query)

# Fetch all the results
# Retrieves all rows from the executed query and stores them in `rows`
rows = cur.fetchall()

# Redirect stdout to a file to save the query results
# This section temporarily redirects output to a file to save the results
orig_stdout = sys.stdout
f = open('/out/humidity_data.txt', 'w')  # File path to save query results
sys.stdout = f

for row in rows:
    print(row)  # Each row (year, max humidity, min humidity) is printed to the file

sys.stdout = orig_stdout  # Reset stdout to default
f.close()  # Close the file

# Close the cursor and connection
# Properly closes the cursor and connection to free up resources
cur.close()
conn.close()

# Prepare data for plotting
# Extracts years, max humidity, and min humidity from query results to use in the plot
years = [row[0] for row in rows]
max_humidity = [row[1] for row in rows]
min_humidity = [row[2] for row in rows]

# Create a plot
# Sets up a line plot for max and min humidity over the years
plt.figure(figsize=(12, 6))
plt.plot(years, max_humidity, marker='o', label='Max Humidity')  # Plot max humidity with markers
plt.plot(years, min_humidity, marker='x', label='Min Humidity')  # Plot min humidity with markers
plt.title('Annual Max and Min Humidity in Delhi')
plt.xlabel('Year')
plt.ylabel('Humidity')
plt.legend()  # Display legend to differentiate max and min humidity lines

# Save the plot to a file
# Saves the generated plot as an image file in the specified directory
plt.savefig('/out/humidity_chart.png')
