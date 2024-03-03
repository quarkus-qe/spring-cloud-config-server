ARG JVM_VERSION=17
ARG JVM_BUILD_TAG=${JVM_VERSION}-jdk
ARG JVM_RUN_TAG=${JVM_VERSION}-jre
ARG BUILD_FROM=eclipse-temurin:${JVM_BUILD_TAG}
ARG RUN_FROM=eclipse-temurin:${JVM_RUN_TAG}

FROM ${BUILD_FROM} as builder
LABEL org.opencontainers.image.authors="Quarkus QE"
WORKDIR /build
COPY . ./
RUN sh mvnw clean package

RUN java -Djarmode=layertools -jar target/spring-cloud-config-4.1.0.jar extract

FROM ${RUN_FROM}
WORKDIR /opt/spring-cloud-config-server
COPY --from=builder /build/dependencies/ ./
COPY --from=builder /build/spring-boot-loader/ ./
COPY --from=builder /build/application/ ./
COPY entrypoint.sh ./

ENV BOOT_LAUNCHER=org.springframework.boot.loader.launch.JarLauncher

WORKDIR /
EXPOSE 8888
VOLUME /config
ENTRYPOINT ["sh", "/opt/spring-cloud-config-server/entrypoint.sh"]
