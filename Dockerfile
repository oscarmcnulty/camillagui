# Use an official Python 3.13 image
FROM python:3.13-rc-bookworm

# Install system packages
RUN apt-get update && apt-get install -y unzip curl

# Create a group and user 'camillagui'
RUN groupadd -r camillagui && useradd -r -g camillagui -m -d /home/camillagui camillagui

# Create app and data directories with proper ownership
RUN mkdir -p /app /data/camillagui /data/camillagui/configs /data/camillagui/coeffs && chown -R camillagui:camillagui /app /data/camillagui

WORKDIR /app

# Download and unzip CamillaGUI backend as root (safe here)
RUN curl -L -o camillagui.zip https://github.com/HEnquist/camillagui-backend/releases/download/v3.0.3/camillagui.zip \
    && unzip camillagui.zip -d camillagui \
    && rm camillagui.zip

# Change ownership of all app files to camillagui user
RUN chown -R camillagui:camillagui /app

# Switch to user 'camillagui'
USER camillagui

# Update config_dir and coeff_dir paths inside config file (run as camillagui user)
RUN sed -i "s|^config_dir:.*|config_dir: \"/data/camillagui/configs\"|" /app/camillagui/config/camillagui.yml \
 && sed -i "s|^coeff_dir:.*|coeff_dir: \"/data/camillagui/coeffs\"|" /app/camillagui/config/camillagui.yml \
 && sed -i "s|^statefile_path:.*|statefile_path: \"/data/camillagui/statefile.yml\"|" /app/camillagui/config/camillagui.yml \
 && sed -i "s|^log_file:.*|log_file: \"/data/camillagui/camilladsp.log\"|" /app/camillagui/config/camillagui.yml

 # Install Python dependencies (run as camillagui user)
RUN pip install --no-cache-dir -r /app/camillagui/requirements.txt

# Expose the GUI port
EXPOSE 5005

# Declare single volume for all data/config
VOLUME ["/data/camillagui"]

# Copy entrypoint and make executable (do this as root, then switch user)
USER root
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh
USER camillagui

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["python", "camillagui/main.py"]