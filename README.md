# Zomato Dataset - SQL Exploration  

This repository contains SQL scripts and a dataset (CSV file) used for exploring and analyzing the Zomato restaurant dataset. The dataset consists of over **9500 records**, covering details like **restaurant names, locations, cuisines, ratings, and more**.  

## 📌 About This Repository  

- **Database**: MySQL  
- **Contents**: SQL scripts + CSV file  
- **Note**: The SQL scripts are not in a strict step-by-step order but cover various aspects of data exploration.  

## 📂 Files in This Repository  

- `zmt_sql_script.sql` → Contains SQL scripts used for data cleaning and transformation.  
- `Zomato_Dataset.csv` → Original dataset used for analysis.  

## 🔧 SQL Operations Performed  

1. Checked column details, data types, and constraints.  
2. Identified and removed duplicate restaurant entries.  
3. Cleaned city names and corrected misspellings.  
4. Merged tables using `JOIN` operations to add **Country_Name** using **CountryCode** as the key.  
5. Used **window functions** to calculate rolling counts of restaurants.  
6. Computed min, max, and average values for **votes, ratings, and currency-related data**.  
7. Created a **category column** for rating segmentation.  

## 🚀 How to Use  

1. Import the `Zomato Dataset.csv` file into MySQL.  
2. Run the `zmt_sql_script.sql` script step by step in MySQL Workbench or any SQL client.  
3. Modify queries as needed for further exploration.  

## 🔗 Connect with Me  

If you find this useful or have any suggestions, feel free to **star ⭐ the repo** and reach out! 
