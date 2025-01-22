FROM alpine:latest as download

# Instala las dependencias necesarias
RUN apk add --no-cache wget unzip

# Define la versión específica de PocketBase
ENV POCKETBASE_VERSION=0.22.28

# Descarga y descomprime el binario de la versión especificada
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip \
    && unzip pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip \
    && chmod +x /pocketbase

FROM alpine:latest

# Instala las dependencias necesarias
RUN apk add --no-cache ca-certificates

# Copia el binario descargado desde la etapa anterior
COPY --from=download /pocketbase /usr/local/bin/pocketbase

# Expone el puerto 8090
EXPOSE 8090

# Comando de inicio
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/root/pocketbase"]
