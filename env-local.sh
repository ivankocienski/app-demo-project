
#
# database (container)
#
export DB_ADDRESS=172.17.0.1 # the container bridge address (to host OS)
export DB_PORT=5432

# warning: if you change these then remember to update the
#   SQL scripts in db/init.d/*
export DB_NAME=api_demo_db
export DB_USER=api_demo_role
export DB_PASSWORD=password

#
# back end server
#
export APP_BE_LISTEN_ON=0.0.0.0:8002
export APP_BE_PGCONFIG="${DB_USER}:${DB_PASSWORD}@${DB_ADDRESS}:${DB_PORT}/${DB_NAME}"

#
# front end server (local dev)
#
export APP_FE_LISTEN_ADDRESS=0.0.0.0
export APP_FE_LISTEN_PORT=5000

#
# front end payload
#
export APP_FE_API_HOST="http://${APP_BE_LISTEN_ON}"

