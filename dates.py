import csv
from datetime import datetime, timedelta
import jdatetime

start_date = datetime.today()-timedelta(days=20)
end_date = start_date + timedelta(days=365 * 3)

output_file = "dim_date_3years.csv"


def get_quarter(month):
    return (month - 1) // 3 + 1


weekday_map_shamsi = {
    0: "دوشنبه",
    1: "سه‌شنبه",
    2: "چهارشنبه",
    3: "پنج‌شنبه",
    4: "جمعه",
    5: "شنبه",
    6: "یک‌شنبه",
}

with open(output_file, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)

    writer.writerow([
        "key_date", "key_date_shamsi", "year", "year_shamsi", "quarter", "quarter_shamsi",
        "month", "month_shamsi", "day_weak", "day_weak_shamsi"
    ])

    current_date = start_date
    while current_date <= end_date:
        g_date = current_date
        s_date = jdatetime.date.fromgregorian(date=g_date)

        year = g_date.year
        quarter = get_quarter(g_date.month)
        month = g_date.month
        weekday = g_date.weekday()  # Monday=0

        year_shamsi = s_date.year
        month_shamsi = s_date.month
        quarter_shamsi = get_quarter(month_shamsi)
        weekday_shamsi = weekday_map_shamsi[s_date.weekday()]

        writer.writerow([
            g_date.strftime('%Y-%m-%d'),
            s_date.strftime('%Y-%m-%d'),
            year,
            str(year_shamsi),
            quarter,
            str(quarter_shamsi),
            month,
            str(month_shamsi),
            weekday + 1,
            weekday_shamsi
        ])

        current_date += timedelta(days=1)

print(f"✅ CSV file with 3 years of date data saved as: {output_file}")
