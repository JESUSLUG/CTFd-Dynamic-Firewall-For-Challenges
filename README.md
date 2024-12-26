# CTFd-Dynamic-Firewall-For-Challenges (CGP)

Este repositorio tiene como objetivo facilitar la implementación de la plataforma **CTFd** junto con el plugin de **TheFlash2k**, llamado "CTFd Docker Containers Plugin".  

## Problemática

El problema principal radica en que este plugin no está diseñado para integrarse fácilmente con plataformas en la nube. Cuando se levanta un reto desde un contenedor Docker, el usuario no puede acceder a este debido a las reglas de firewall del servicio en la nube.  

## Solución

Con este repositorio, se busca proporcionar una guía rápida para:  
1. Instalar **CTFd** junto con el plugin mencionado.  
2. Incluir un script que funcione dentro de máquinas virtuales (VMs) de **Google Cloud Platform** (GCP).  

El propósito del script es gestionar dinámicamente las reglas de firewall según los contenedores creados por el plugin.  

### Funcionamiento del Script

- El plugin "CTFd Docker Containers Plugin" genera nuevos contenedores basados en un contenedor original y asigna un puerto aleatorio, manteniendo el mismo nombre que el contenedor base.  
- El script monitorea los contenedores creados, ignorando el contenedor original y sus puertos.  
- Cuando se detecta un nuevo contenedor (basado del ya existente), el script crea automáticamente una regla de firewall en GCP para permitir el acceso al puerto asignado.  
- Asimismo, al detectar que un contenedor ha dejado de funcionar, el script elimina la regla de firewall correspondiente para mantener la seguridad de la plataforma.  


El repo de TheFlash2k: [https://github.com/TheFlash2k/containers](https://github.com/TheFlash2k/containers).

El repo oficinal de CTFd: [https://github.com/CTFd/CTFd](https://github.com/CTFd/CTFd).

---

# Script.sh

Este script tiene como objetivo principal crear una regla de firewall para cada puerto generado por el contenedor del reto. La imagen diseñada para el reto genera puertos dinámicos a medida que el contenedor se levanta, y el script asegura que una regla de firewall se cree para permitir el acceso del competidor a cada puerto asignado por el contenedor.

## Descripción de Funcionamiento Actual

El script identifica los puertos que el contenedor expone y, para cada uno de ellos, crea una regla de firewall en Google Cloud, permitiendo el acceso a los puertos generados por el contenedor. En su implementación actual, el script está diseñado para funcionar con puertos asignados por defecto (4444/tcp), pero también detecta los puertos generados dinámicamente y los registra en las reglas de firewall.

### Funcionalidades añadidas

1. **Gestión de puertos dinámicos**: El script detecta puertos dinámicos generados por el contenedor y crea reglas de firewall para ellos.
2. **Eliminación de reglas huérfanas**: Si un contenedor se detiene o elimina, el script también elimina las reglas de firewall correspondientes para los puertos que ya no están siendo utilizados.
3. **Ignorar el puerto 4444**: El script ahora ignora el puerto 4444 por defecto, evitando que se cree o se elimine una regla de firewall para dicho puerto.

## Áreas de Mejora y Puntos Pendientes

Es importante señalar que aún existen algunos detalles pendientes por mejorar en el script:

1. **Gestión de puertos por defecto**: Aunque ahora se ignora el puerto 4444, algunas versiones futuras pueden añadir más control sobre los puertos predeterminados.
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
4. **Iniciar sesion en la VM**

   Si estás utilizando gcloud directamente en la VM, asegúrate de que has iniciado sesión correctamente con los permisos adecuados.
   gcloud auth login
  ```bash
gcloud auth login
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

## Cómo ejecutar el script en segundo plano

Para ejecutar el script en segundo plano y asegurarte de que siga funcionando incluso si cierras la sesión, puedes usar el siguiente comando:

```bash
nohup ./Script.sh &> script_output.log &
```

Este comando redirige la salida estándar a un archivo `script_output.log`, y el proceso continuará ejecutándose en segundo plano.

---

## Ver el estado del script

Si deseas verificar el estado del script mientras está ejecutándose, puedes usar el siguiente comando para ver la salida en tiempo real:

```bash
tail -f script_output.log
```

Además, si quieres asegurarte de que el script está corriendo en segundo plano, puedes buscar el proceso ejecutándose con el comando `ps`:

```bash
ps aux | grep Script.sh
```

Esto te mostrará si el script está en ejecución y su ID de proceso.

---

## Notas Importantes

- **Permisos de Google Cloud**: Asegúrate de tener acceso a los roles de propietario del proyecto y Administrador de Red de Compute en el proyecto de Google Cloud donde deseas ejecutar el script.
  
- **Acceso a la VM**: El script debe ejecutarse dentro de una máquina virtual en Google Cloud que tenga acceso a Docker y los permisos adecuados para gestionar las reglas de firewall.

- **Redirección de salida**: El script redirige la salida estándar a un archivo de log llamado `script_output.log`. Puedes revisar este archivo para ver el progreso y los resultados del script.

    Para ver la salida en tiempo real, puedes usar el siguiente comando:

    ```bash
    tail -f script_output.log
    ```

---
