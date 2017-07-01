FROM debian:stretch
MAINTAINER piotr.figlarek@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# always use bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# as defined on http://docs.readthedocs.io/en/latest/install.html
RUN apt-get update
RUN apt-get -y install build-essential
RUN apt-get -y install python-dev python-pip python-setuptools
RUN apt-get -y install libxml2-dev libxslt1-dev zlib1g-dev
RUN apt-get -y install redis-server

# to allow rtd to generate pdf
RUN apt-get -y install --no-install-recommends texlive-latex-extra texlive-fonts-recommended

# the rest of handy tools
RUN apt-get -y install plantuml git vim
RUN pip install --upgrade pip
RUN pip install sphinxcontrib-plantuml

# to enable SSL mails from rtd
RUN pip install django-smtp-ssl

RUN mkdir /www
RUN cd /www && git clone https://github.com/rtfd/readthedocs.org.git && pip install -r readthedocs.org/requirements.txt

# Deploy the database
RUN cd /www/readthedocs.org && python ./manage.py migrate

# Create a super user
RUN cd /www/readthedocs.org && echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python ./manage.py shell

# install test_data fixture
RUN cd /www/readthedocs.org && python ./manage.py loaddata test_data

# copy static files
RUN cd /www/readthedocs.org && python ./manage.py collectstatic --noinput

# apply local configuration
COPY files/local_settings.py /www/readthedocs.org/readthedocs/settings/local_settings.py


RUN pip install supervisor
ADD files/supervisord.conf /etc/supervisord.conf

CMD ["supervisord"]

EXPOSE 8000
