FROM python:3.12-slim

WORKDIR /APP

COPY app.py Main.py requirements.txt ./

RUN pip3 install -r requirements.txt

CMD ["python", "app.py"]