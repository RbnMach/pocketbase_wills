FROM alpine:latest as download

# Instala las dependencias necesarias
RUN apk add curl wget unzip

# Especifica la versión deseada de PocketBase
ENV POCKETBASE_VERSION=0.22.28

# Descarga el binario de la versión especificada
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip \
    && unzip pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip \
    && chmod +x /pocketbase

# Crea la etapa final
FROM alpine:latest

# Instala las dependencias necesarias en la imagen final
RUN apk update && apk add --update git build-base ca-certificates && rm -rf /var/cache/apk/*

# Copia el binario descargado desde la etapa de compilación
COPY --from=download /pocketbase /usr/local/bin/pocketbase

# Expone el puerto 8090
EXPOSE 8090

# Configura el comando de inicio
ENTRYPOINT /usr/local/bin/pocketbase serve --http=0.0.0.0:8090 --dir=/root/pocketbase
