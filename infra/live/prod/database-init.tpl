apiVersion: batch/v1
kind: Job
metadata:
  name: database-init
spec:
  activeDeadlineSeconds: 30
  completions: 1
  parallelism: 1
  template:
    metadata:
      name: init-database
    spec:
      containers:
      - name: init
        image: ${IMAGEDATABASE}:latest
        command: ["/bin/bash","-c", "mysql -uadmin -padmin1234 -h${MYSQLHOST} < /docker-entrypoint-initdb.d/init.sql"]
      restartPolicy: Never