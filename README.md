# CTFd-and-Container
This repository uses the plugin developed by TheFlash2k, their CTFd plugin. In this repository, we aim to provide a solution to the CGP firewall rules using a script that leverages its API.

For the less attentive, the purpose of this repository is to work on and explain how to achieve this. Basically, what we want to do is enable competitors to deploy their own challenge (in the form of a container) during the competition, ensuring each participant has their own instance. This approach is similar to how HTB labs work.

Attached is the link to TheFlash2k's repository: [https://github.com/TheFlash2k/containers](https://github.com/TheFlash2k/containers).

And of course, here is the link to the CTFd repository as well: [https://github.com/CTFd/CTFd](https://github.com/CTFd/CTFd).

# Script.sh
Este script tiene como objetivo principal crear una regla de firewall para cada puerto generado por el contenedor del reto. La imagen diseñada para el reto genera puertos dinámicos a medida que el contenedor se levanta, y el script asegura que una regla de firewall se cree para permitir el acceso del competidor a cada puerto asignado por el contenedor.

Descripción de Funcionamiento Actual

El script identifica los puertos que el contenedor expone y, para cada uno de ellos, crea una regla de firewall en Google Cloud, permitiendo el acceso a los puertos generados por el contenedor. En su implementación actual, el script está diseñado para funcionar con puertos asignados por defecto (4444/tcp), pero también detecta los puertos generados dinámicamente y los registra en las reglas de firewall. 

Áreas de Mejora y Puntos Pendientes

Es importante señalar que aún existen algunos detalles pendientes por mejorar en el script:

Gestión de puertos por defecto: Actualmente, el script levanta una regla de firewall para el puerto por defecto (4444), pero aún no gestiona correctamente otros puertos generados dinámicamente, lo que se ajustará en futuras versiones.
Reglas de firewall persistentes: El script no elimina automáticamente las reglas de firewall cuando un contenedor asociado muere. Esta es otra área que se encuentra en desarrollo, y se implementará en una versión futura del script para asegurar que las reglas de firewall no queden huérfanas de contenedores activos.


Aquí tienes un ejemplo de cómo podrías redactar el archivo README para que sea claro y fácil de seguir:

## Requisitos Previos

Para usar este script, es necesario contar con los siguientes permisos:

1. **Ser propietario del proyecto en Google Cloud.**
   - Es necesario tener privilegios de propietario para poder crear y modificar reglas de firewall.
   
2. **Ser Administrador de Red de Compute (Compute Network Admin).**
   - Este rol es necesario para gestionar las reglas de firewall dentro del proyecto.

   Si no estás familiarizado con los permisos en Google Cloud, te recomendamos leer la documentación sobre [IAM (Identity and Access Management)](https://cloud.google.com/iam) para comprender cómo asignar estos roles y permisos.

## Configuración del Script

### 1. Asignar permisos al script

Para que el script pueda ejecutarse correctamente en tu VM, es necesario asignarle permisos de ejecución. Esto se puede hacer utilizando el siguiente comando:

```bash
chmod +x Script.sh
```

### 2. Ejecutar el script

Una vez que hayas asignado permisos de ejecución al script, puedes ejecutarlo de la siguiente manera:

```bash
./Script.sh
```

El script se ejecutará en segundo plano, monitorizando los puertos de los contenedores y creando las reglas de firewall necesarias. 

## Notas Importantes

- **Permisos de Google Cloud**: Asegúrate de tener acceso a los roles de propietario del proyecto y Administrador de Red de Compute en el proyecto de Google Cloud donde deseas ejecutar el script.
  
- **Acceso a la VM**: El script debe ejecutarse dentro de una máquina virtual en Google Cloud que tenga acceso a Docker y los permisos adecuados para gestionar las reglas de firewall.

- **Redirección de salida**: El script redirige la salida estándar a un archivo de log llamado `script_output.log`. Puedes revisar este archivo para ver el progreso y los resultados del script.

    Para ver la salida en tiempo real, puedes usar el siguiente comando:

    ```bash
    tail -f script_output.log
    ```
