#!/bin/bash

# Nombre del contenedor y proyecto
CONTAINER_NAME="catacumbasdeldev-easy_web:latest"
PROJECT_ID="ElIDdeTuProyecto"

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

    # Eliminar las reglas de firewall que no están siendo usadas
    # Obtener todos los números de puerto de las reglas de firewall existentes
    EXISING_RULES=$(gcloud compute firewall-rules list --project="$PROJECT_ID" --filter="name=catacumbadeldev" --format="json")

    for RULE in $(echo "$EXISING_RULES" | jq -r '.[] | .name'); do
        # Extraer el puerto de la regla
        RULE_PORT=$(echo "$EXISING_RULES" | jq -r ".[] | select(.name==\"$RULE\") | .allowed[].ports[]")

        # Verificar si este puerto está en uso por algún contenedor
        PORT_IN_USE=$(echo "$CONTAINER_PORTS" | grep -w "$RULE_PORT")

        # Si el puerto no está en uso, eliminar la regla de firewall
        if [[ -z "$PORT_IN_USE" ]]; then
            echo "La regla de firewall $RULE para el puerto $RULE_PORT no está en uso. Eliminándola..."
            gcloud compute firewall-rules delete "$RULE" --project="$PROJECT_ID" --quiet
        fi
    done

    # Espera 20 segundos antes de volver a ejecutar
    sleep 20
done
