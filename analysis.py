import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt


def run_libranet_analysis():
    conn = mysql.connector.connect(
        host="localhost",
        user="libranet_user",
        password="your_password",
        database="libranet_db",
    )
    df = pd.read_sql("SELECT * FROM vw_library_circulation;", conn)
    conn.close()

    df["loan_date"] = pd.to_datetime(df["loan_date"])
    df["month"] = df["loan_date"].dt.strftime("%b")

    fig, axes = plt.subplots(2, 1, figsize=(10, 7))

    # Top Panel: Monthly Library Book Circulation Trends
    monthly = df.groupby("month").size()
    monthly.plot(kind="line", marker="o", ax=axes[0], color="#2b6cb0", linewidth=2)
    axes[0].set_title("Monthly Library Book Circulation Trends")
    axes[0].set_ylabel("Number of Borrowed Books")
    axes[0].grid(True, linestyle="--", alpha=0.6)

    # Bottom Panel: Subject-Wise Borrowing Demand
    subj = df["subject"].value_counts()
    subj.plot(kind="bar", ax=axes[1], color="#3182ce")
    axes[1].set_title("Subject-Wise Borrowing Demand")
    axes[1].set_ylabel("Borrowing Count")
    axes[1].tick_params(axis="x", rotation=0)

    plt.tight_layout()
    plt.savefig("libranet_circulation_charts.png", dpi=300)
    plt.close()


if __name__ == "__main__":
    run_libranet_analysis()
