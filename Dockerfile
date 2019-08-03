FROM openjdk:8-jre
ENV VERSION=5.0.5

RUN set -eux; \
	apt-get update && apt-get upgrade -y; \
	apt-get install -y --no-install-recommends \
		# utilities for keeping Debian and OpenJDK CA certificates in sync
		ca-certificates \
		p11-kit \
		# required packages
		curl \
		dirmngr \
		gnupg \
		lib32z1 \
		unzip \
		wget \
	; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*_dists_*

WORKDIR /app

RUN set -eux; \
	wget -r -l 99 -np -nH -R index.html --cut-dirs=2 -e robots=off https://mirror.gravit.pro/build/v${VERSION}/; \
	unzip libraries.zip; \
	find . -iname '*.tmp' -delete

CMD ["java", "-javaagent:LaunchServer.jar", "-jar", "LaunchServer.jar"]

EXPOSE 9274
VOLUME ["/app"]
