FROM openjdk:8-jdk
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
    openjfx \
		unzip \
		wget \
	; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*_dists_*

WORKDIR /app

RUN set -eux; \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64/bin/javafxpackager /usr/local/openjdk-8/bin/; \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64/bin/javapackager /usr/local/openjdk-8/bin/; \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/jfxrt.jar /usr/local/openjdk-8/jre/lib/ext/; \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/javafx.properties /usr/local/openjdk-8/jre/lib/; \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/jfxswt.jar /usr/local/openjdk-8/jre/lib/; \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64/lib/ant-javafx.jar /usr/local/openjdk-8/lib/; \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64/lib/javafx-mx.jar /usr/local/openjdk-8/lib/; \
  \
  git clone -b v${VERSION} https://github.com/GravitLauncher/Launcher.git; \
  cd Launcher; \
  sed -i 's/git@github.com:/https:\/\/github.com\//gmi' .gitmodules; \
  git submodule sync ; git submodule update --init --recursive; \
  sh gradlew build

WORKDIR /app/Launcher/LaunchServer/build/libs

CMD ["java", "-javaagent:LaunchServer.jar", "-jar", "LaunchServer.jar"]

EXPOSE 9274
VOLUME ["/app"]
