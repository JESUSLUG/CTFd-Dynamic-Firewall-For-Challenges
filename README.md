# CTFd-and-Container
This repository uses the plugin developed by TheFlash2k, their CTFd plugin. In this repository, we aim to provide a solution to the CGP firewall rules using a script that leverages its API.

For the less attentive, the purpose of this repository is to work on and explain how to achieve this. Basically, what we want to do is enable competitors to deploy their own challenge (in the form of a container) during the competition, ensuring each participant has their own instance. This approach is similar to how HTB labs work.

Attached is the link to TheFlash2k's repository: [https://github.com/TheFlash2k/containers](https://github.com/TheFlash2k/containers).

And of course, here is the link to the CTFd repository as well: [https://github.com/CTFd/CTFd](https://github.com/CTFd/CTFd).
Aquí tienes una versión actualizada del README con los detalles que mencionas, incluyendo los requisitos de instalación para que el script funcione sin problemas:

---

# Script.sh

Este script tiene como objetivo principal crear una regla de firewall para cada puerto generado por el contenedor del reto. La imagen diseñada para el reto genera puertos dinámicos a medida que el contenedor se levanta, y el script asegura que una regla de firewall se cree para permitir el acceso del competidor a cada puerto asignado por el contenedor.

## Descripción de Funcionamiento Actual

El script identifica los puertos que el contenedor expone y, para cada uno de ellos, crea una regla de firewall en Google Cloud, permitiendo el acceso a los puertos generados por el contenedor. En su implementación actual, el script está diseñado para funcionar con puertos asignados por defecto (4444/tcp), pero también detecta los puertos generados dinámicamente y los registra en las reglas de firewall.

### Funcionalidades añadidas

1. **Gestión de puertos dinámicos**: El script detecta puertos dinámicos generados por el contenedor y crea reglas de firewall para ellos.
2. **Eliminación de reglas huérfanas**: Si un contenedor se detiene o elimina, el script también elimina las reglas de firewall correspondientes para los puertos que ya no están siendo utilizados.

## Áreas de Mejora y Puntos Pendientes

Es importante señalar que aún existen algunos detalles pendientes por mejorar en el script:

1. **Gestión de puertos por defecto**: Actualmente, el script levanta una regla de firewall para el puerto por defecto (4444). Aunque ya gestiona los puertos dinámicos, es importante que ignore este puerto por defecto en futuras versiones.
2. **Reglas de firewall persistentes**: El script actualmente elimina las reglas de firewall solo cuando un contenedor asociado se elimina. Este comportamiento será más robusto en versiones futuras para asegurarse de que las reglas huérfanas no permanezcan.

---

## Requisitos Previos

Para usar este script, es necesario contar con los siguientes permisos:

1. **Ser propietario del proyecto en Google Cloud.**
   - Es necesario tener privilegios de propietario para poder crear y modificar reglas de firewall.
   
2. **Ser Administrador de Red de Compute (Compute Network Admin).**
   - Este rol es necesario para gestionar las reglas de firewall dentro del proyecto.

Si no estás familiarizado con los permisos en Google Cloud, te recomendamos leer la documentación sobre [IAM (Identity and Access Management)](https://cloud.google.com/iam) para comprender cómo asignar estos roles y permisos.

3. **Instalar Docker en la VM.**
   - Asegúrate de tener Docker instalado y funcionando en la máquina virtual donde ejecutarás el script.
   
4. **Instalar las herramientas necesarias:**

   Antes de ejecutar el script, necesitarás tener instalados ciertos paquetes en tu sistema, especialmente `jq` para procesar la salida de las reglas de firewall en formato JSON. Para instalar `jq`:

   **En sistemas Debian/Ubuntu**:
   ```bash
   sudo apt-get update
   sudo apt-get install jq
   ```

   **En sistemas RHEL/CentOS**:
   ```bash
   sudo yum install jq
   ```

   **En sistemas Fedora**:
   ```bash
   sudo dnf install jq
   ```

   Además, necesitarás las herramientas de Google Cloud SDK (`gcloud`) instaladas y configuradas en tu VM para poder gestionar las reglas de firewall. Si aún no tienes Google Cloud SDK, puedes instalarlo siguiendo las instrucciones de la [documentación oficial](https://cloud.google.com/sdk/docs/install).

---

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

---

## Notas Importantes

- **Permisos de Google Cloud**: Asegúrate de tener acceso a los roles de propietario del proyecto y Administrador de Red de Compute en el proyecto de Google Cloud donde deseas ejecutar el script.
  
- **Acceso a la VM**: El script debe ejecutarse dentro de una máquina virtual en Google Cloud que tenga acceso a Docker y los permisos adecuados para gestionar las reglas de firewall.

- **Redirección de salida**: El script redirige la salida estándar a un archivo de log llamado `script_output.log`. Puedes revisar este archivo para ver el progreso y los resultados del script.

    Para ver la salida en tiempo real, puedes usar el siguiente comando:

    ```bash
    tail -f script_output.log
    ```

- **Eliminación de reglas huérfanas**: El script ahora elimina automáticamente las reglas de firewall para puertos que ya no están siendo utilizados por contenedores activos, lo que evita la acumulación de reglas innecesarias.

---
