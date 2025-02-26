FROM alpine:latest as download

# Instala las dependencias necesarias
RUN apk add curl wget unzip

# Define la versión específica de PocketBase que deseas
ENV POCKETBASE_VERSION=0.25.8

# Descarga el binario de la versión deseada
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip \
    && unzip pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip \
    && chmod +x /pocketbase

# Etapa final
FROM alpine:latest

# Instala dependencias necesarias
RUN apk update && apk add --update git build-base ca-certificates && rm -rf /var/cache/apk/*

# Copia el binario descargado desde la etapa anterior
COPY --from=download /pocketbase /usr/local/bin/pocketbase

# Expone el puerto para el servidor de PocketBase
EXPOSE 8090

# Comando de entrada para ejecutar PocketBase
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/root/pocketbase"]
