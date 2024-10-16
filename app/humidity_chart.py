import sys
import psycopg2
import matplotlib.pyplot as plt

# Connect to your PostgreSQL database
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="postgres",
    host="postgresdb",
    port="5432"
)

# Create a cursor object
cur = conn.cursor()

# Execute the query
query = """
SELECT date_trunc('year', date) AS year, max(humidity), min(humidity) 
FROM daily_delhi_climate_train 
GROUP BY year
"""
cur.execute(query)

# Fetch all the results
rows = cur.fetchall()

# Print results
orig_stdout = sys.stdout
f = open('/out/humidity_data.txt', 'w')
sys.stdout = f

for row in rows:
    print(row)

sys.stdout = orig_stdout
f.close()

# Close the cursor and connection
cur.close()
conn.close()

# Prepare data for plotting
years = [row[0] for row in rows]
max_humidity = [row[1] for row in rows]
min_humidity = [row[2] for row in rows]

# Create a plot
plt.figure(figsize=(12, 6))
plt.plot(years, max_humidity, marker='o', label='Max Humidity')
plt.plot(years, min_humidity, marker='x', label='Min Humidity')
plt.title('Annual Max and Min Humidity in Delhi')
plt.xlabel('Year')
plt.ylabel('Humidity')
plt.legend()

# Save the plot to a file
plt.savefig('/out/humidity_chart.png')
