FROM swipl:latest

# Устанавливаем зависимости для ODBC и PostgreSQL
RUN apt-get update && apt-get install -y \
    unixodbc \
    libodbc1 \
    odbcinst1debian2 \
    odbc-postgresql \
    && rm -rf /var/lib/apt/lists/* \
    && echo "[PostgreSQL_facts_db]" > /etc/odbc.ini \
    && echo "Driver = /usr/lib/aarch64-linux-gnu/odbc/psqlodbcw.so" >> /etc/odbc.ini \
    && echo "Database = facts_db" >> /etc/odbc.ini \
    && echo "Server = /var/run/postgresql/.s.PGSQL.5432" >> /etc/odbc.ini \
    && echo "Username = prolog_user" >> /etc/odbc.ini \
    && echo "Password = prolog_pass" >> /etc/odbc.ini \
    $$ psql -U prolog_user -d facts_db -c "CREATE TABLE environment(key TEXT PRIMARY KEY, value TEXT);"

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы с кодом Prolog в контейнер
COPY . /app

# Открываем порты
EXPOSE 8000

# Запуск Prolog-сервера
CMD swipl -s server.pl
