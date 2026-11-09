FROM node:10

# node:10 is based on Debian stretch (EOL), whose repos were moved to archive.debian.org
RUN echo "Pointing apt at the Debian archive" \
	&& sed -i -e 's|deb.debian.org/debian|archive.debian.org/debian|g' \
		-e 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' \
		-e '/stretch-updates/d' \
		/etc/apt/sources.list \
	&& echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive

RUN echo "Updating Packages" \
	&& apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y --allow-unauthenticated --assume-yes \
		curl \
		git \
		python \
		build-essential \
		xvfb \
		apt-transport-https
		
RUN echo "Installing yarn" \
	&& npm install -g --force yarn
	

ADD locker /opt/learninglocker
WORKDIR /opt/learninglocker

COPY .env ./.env

RUN echo "Building Services" \
	&& rm yarn.lock \
	&& npm_config_build_from_source=true yarn install --ignore-engines \
	&& yarn build-all
	
#RUN echo "Fixing asset path" \
#	&& cp -r ui/dist/server ../public \
#	&& cp -r ui/dist/server public \
#	&& cp -r ui/dist/server ui/public \
#	&& cp -r ui/dist/server ui/dist/public


