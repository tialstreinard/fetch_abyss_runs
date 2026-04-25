# Abyss Tracker Data
Simple bash script to fetch all runs from Abyss Tracker, an EVE Online Abyssal Deadspace aggregator.
Having your own data allows further analysis for your character runs, without burdening Abyss Tracker devs for new features (eg break your own runs down by tier, weather, hull, class, etc)

## Notes
- Be respectful of the Abyss Tracker servers and take your time with the API calls
- Adjust the parameters as you go along to fetch data in small chunks
- The script starts getting data from the top (most recent runs first)
- Keep in mind that data are *voluntarily submitted by the Community* and, as such, may contain inconsistencies

## How to run
[This script]is the simplest iteration to obtain run data.

Download or copy the script, then:

`chmod +x abyss_runs_simplest.sh`

`./abyss_runs_simplest.sh`

Repeat as needed with new parameters and file names to get more data. 
