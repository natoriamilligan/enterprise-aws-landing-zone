FROM python
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt
COPY . .
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--access-logfile", "-", "--error-logfile", "-", "app:app"]
