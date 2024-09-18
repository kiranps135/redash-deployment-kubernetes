divert(-1)
define(redash_environment, `
        - name: PYTHONUNBUFFERED
          value: "0"
        - name: REDASH_REDIS_URL
          value: "redis://127.0.0.1:6379/0"
        - name: REDASH_MAIL_USERNAME
          value: "redash"
        - name: REDASH_MAIL_USE_TLS
          value: "true"
        - name: REDASH_MAIL_USE_SSL
          value: "false"
        - name: REDASH_MAIL_SERVER
          value: "mail.example.net"
        - name: REDASH_MAIL_PORT
          value: "587"
        - name: REDASH_MAIL_PASSWORD
          value: "password"
        - name: REDASH_MAIL_DEFAULT_SENDER
          value: "redash@mail.example.net"
        - name: REDASH_LOG_LEVEL
          value: "INFO"
        - name: REDASH_DATABASE_URL
          value: "postgresql://redash:redash@127.0.0.1:5432/redash"
        - name: REDASH_COOKIE_SECRET
          value: "not-so-secret"
        - name: REDASH_ADDITIONAL_QUERY_RUNNERS
          value: "redash.query_runner.python"
')

divert(0)
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redash
  labels:
    app: redash
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redash
  strategy:
    rollingUpdate:
      maxSurge: 0
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: redash
    spec:
      containers:
      - name: redis
        image: redis
        ports:
        - name: redis
          containerPort: 6379
      - name: postgres
        image: postgres:11
        env:
        - name: POSTGRES_USER
          value: redash
        - name: POSTGRES_PASSWORD
          value: redash
        - name: POSTGRES_DB
          value: redash
        ports:
        - name: postgres
          containerPort: 5432
      - name: server
        image: redash/redash
        args: [ "server" ]
        env:
        - name: REDASH_WEB_WORKERS
          value: "2"
        redash_environment
        ports:
        - name: redash
          containerPort: 5000
      - name:  scheduler
        image: redash/redash
        args: [ "scheduler" ]
        env:
        - name: QUEUES
          value: "celery"
        - name: WORKERS_COUNT
          value: "1"
        redash_environment
      - name: schedulded-worker
        image: redash/redash
        args: [ "worker" ]
        env:
        - name: QUEUES
          value: "scheduled_queries,schemas"
        - name: WORKERS_COUNT
          value: "1"
      - name: adhoc-worker
        image: redash/redash
        args: [ "worker" ]
        env:
        - name: QUEUES
          value: "queries"
        - name: WORKERS_COUNT
          value: "1"
        redash_environment
---
apiVersion: v1
kind: Service
metadata:
  name: redash-nodeport
spec:
  type: NodePort
  selector:
    app: redash
  ports:
  - port: 5000
    targetPort: 5000
