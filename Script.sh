#!/bin/bash

# Nombre del contenedor y proyecto
CONTAINER_NAME="catacumbasdeldev-easy_web:latest"
PROJECT_ID="Aqui va el ID de tu proyecto de Google Cloud"

while true; do
    # Obtener los puertos de los contenedores que están usando la imagen catacumbasdeldev-easy_web:latest
    CONTAINER_PORTS=$(docker ps --filter "ancestor=$CONTAINER_NAME" --format '{{.Ports}}' | awk -F'->' '{print $1}' | cut -d':' -f2)

    if [[ -z "$CONTAINER_PORTS" ]]; then
        echo "No se encontró un contenedor en ejecución con la imagen $CONTAINER_NAME"
    else
        # Para cada puerto detectado, verifica si existe la regla de firewall 
        for CONTAINER_PORT in $CONTAINER_PORTS; do
            echo "Puerto detectado: $CONTAINER_PORT"

            # Verificar si existe una regla de firewall para ese puerto
            EXISTING_RULE=$(gcloud compute firewall-rules list --project="$PROJECT_ID" --filter="name=catacumbadeldev" --format="json" | jq '.[] | select(.allowed[]?.ports[] == "'$CONTAINER_PORT'")')

            if [[ -z "$EXISTING_RULE" ]]; then
                echo "No existe una regla de firewall para el puerto $CONTAINER_PORT. Creando una nueva..."

                # Crear una nueva regla de firewall
                gcloud compute firewall-rules create "allow-catacumbadeldev-$CONTAINER_PORT" \
                    --project="$PROJECT_ID" \
                    --allow="tcp:$CONTAINER_PORT" \
                    --direction=INGRESS \
                    --priority=1000 \
                    --network="default" \
                    --source-ranges="0.0.0.0/0"

                echo "Regla de firewall creada para el puerto $CONTAINER_PORT."
            else
                echo "Ya existe una regla de firewall para el puerto $CONTAINER_PORT."
            fi
        done
    fi

    # Espera 20 segundos antes de volver a ejecutar
    sleep 20
done
