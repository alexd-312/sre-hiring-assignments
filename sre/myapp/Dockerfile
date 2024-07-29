FROM python:3.12-alpine AS builder
WORKDIR /build
COPY requirements.txt /build
RUN pip install -r requirements.txt
COPY . .

FROM builder AS run-app
ARG GO_APP_ADDRESS
ARG MYAPP_TMP_FOLDER
ENTRYPOINT ["python3"]
CMD ["main.py"]