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
