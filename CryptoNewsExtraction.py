bq_assistant = BigQueryHelper("bigquery-public-data", "hacker_news")
# print(bq_assistant.table_schema("full"))
bq_assistant.head("full", num_rows=3)

QUERY = """SELECT title, time
           FROM `bigquery-public-data.hacker_news.full`
           WHERE REGEXP_CONTAINS(title, r"(b|B)itcoin")
           ORDER BY time ASC;
        """

df = bq_assistant.query_to_pandas(QUERY)

df.time = df.time.apply(lambda d: datetime.datetime.fromtimestamp(int(d)).strftime('%Y-%m-%d'))

d = {'title': '. '.join}
df_new = df.groupby('time', as_index=False).aggregate(d).reindex(columns=df.columns)
df_new.tail()