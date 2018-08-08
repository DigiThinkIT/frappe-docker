FROM bitnami/minideb:jessie

RUN useradd -ms /bin/bash frappe

# Install packages
RUN install_packages git python-dev curl python-pip gcc gnupg apt-transport-https wkhtmltopdf cron nano

# Install bench package and init bench folder
RUN git clone https://github.com/frappe/bench .bench && pip install setuptools wheel && pip install ./.bench

## Yarn Repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

## NodeJS Repo
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN install_packages yarn nodejs

USER frappe
WORKDIR /home/frappe

RUN bench init frappe-bench --frappe-branch develop --skip-redis-config-generation --no-procfile
WORKDIR /home/frappe/frappe-bench

COPY ./common_site_config.json /home/frappe/frappe-bench/sites/

RUN bench get-app erpnext --branch develop

COPY ./apps.txt /home/frappe/frappe-bench/sites/

RUN rm -rf apps/frappe_io apps/foundation apps/frappe/.git apps/erpnext/.git sites/assets
RUN rm -rf /home/frappe/.cache

# CMD ["bench", "serve"]
