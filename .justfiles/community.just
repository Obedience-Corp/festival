# Check feed selection, payload limits, and delivery behavior without posting.
[no-cd]
check:
    PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s scripts -p 'test_discord_content_feed.py'

# Preview current public activity without consuming delivery state or posting.
[no-cd]
preview:
    PYTHONDONTWRITEBYTECODE=1 python3 scripts/discord_content_feed.py --mode weekly
