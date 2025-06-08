#!/bin/bash
set -e

echo "Setting camilla_host=${CAMILLA_HOST} and camilla_port=${CAMILLA_PORT}..."
sed -i "s/^camilla_host:.*/camilla_host: ${CAMILLA_HOST}/" camillagui/config/camillagui.yml
sed -i "s/^camilla_port:.*/camilla_port: ${CAMILLA_PORT}/" camillagui/config/camillagui.yml

# Run the application
exec "$@"