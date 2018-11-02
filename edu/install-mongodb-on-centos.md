author: Kukulkan Team
summary: Instalación de MongoDB en Centos 7
id: install-mongodb-on-centos
categories: instalacion
environments: js
status: draft
analytics account: 0

# Instalación de MongoDB en Centos 7

## Prerequisitos

Duration: 1:00

1. Centos 7 64Bits
2. Acceso como *superusuario*
3. Acceso remoto por medio de *ssh*

## Actualización de paquetes

Duration: 2:00

```bash
sudo yum -y update
sudo yum -y install wget emacs-nox vim
```

## Corrección del *locale*

Duration: 1:00

En caso de que al acceder por *ssh* a la máquina virtual marque un error con el *locale*, se puede corregir agregando dos líneas al archivo `/etc/locale.conf`

```ini
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
```

> Dependiendo del idioma de instalación, puede que lo más correcto sea `LANG=es_MX.UTF-8` y `LC_ALL=es_MX.UTF-8`.

## Puertos en el firewall

Duration: 1:00

En caso de que el *firewall* esté activo (`sudo systemctl status firewalld`), se deberán abrir los puertos de *tomcat* en el *firewall*

```bash
sudo firewall-cmd --zone=public --add-port=27017/tcp --permanent
sudo firewall-cmd --zone=public --add-port=27018/tcp --permanent
sudo firewall-cmd --zone=public --add-port=27019/tcp --permanent
sudo firewall-cmd --zone=public --add-port=28017/tcp --permanent
sudo firewall-cmd --reload
```

> Para verificar `sudo firewall-cmd --list-all`


## Configuración de seguridad

Duration: 5:00

Para algunas operaciones, es requerido que la seguridad de linux sea más laxa, para esto requerimos editar el archivo `/etc/selinux/config` y dejarlo parecido a lo siguiente


```bash
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

> Reiniciar después de modificar el SELinux

## Agregar Repositorio

Duration: 1:00

Creamos el archivo `/etc/yum.repos.d/mongodb-org-3.4.repo` con el siguiente contenido:

```ini
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
```

## Instalar servidor y cliente

Duration:1:00

```bash
sudo yum install -y mongodb-org
```

## Habilitar Servicio

Duration: 1:00

```bash
sudo systemctl enable mongod
sudo systemctl start mongod
```

## Configurar sistema para número de archivos abiertos

Duration: 5:00

MongoDB requiere que el sistema le permita tener un número grande de archivos abiertos por proceso, para esto debemos editar el archivo `/etc/security/limits.d/20-nproc.conf` y agregamos al final

```ini
mongod soft nproc 32000
```

Despues de editar el archivo, requerimos reinicar mongodb:

```bash
sudo systemctl restart mongod
```

### Cambio en paginado en el kernel

Duration: 5:00

Mongo recomienda que el paginado no sea transparente, crear un script de inicialización y un profile.

#### Script de inicialización

Creamos el archivo `/etc/init.d/disable-transparent-hugepages` con el siguiente contenido:

```bash
#!/bin/bash
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > ${thp_path}/enabled
    echo 'never' > ${thp_path}/defrag

    re='^[0-1]+$'
    if [[ $(cat ${thp_path}/khugepaged/defrag) =~ $re ]]
    then
      # RHEL 7
      echo 0  > ${thp_path}/khugepaged/defrag
    else
      # RHEL 6
      echo 'no' > ${thp_path}/khugepaged/defrag
    fi

    unset re
    unset thp_path
    ;;
esac
```

Habilitando el script:

```bash
sudo chmod 755 /etc/init.d/disable-transparent-hugepages
sudo chkconfig --add disable-transparent-hugepages
sudo /etc/init.d/disable-transparent-hugepages start
```

## Creando profile

Duration: 3:00

Creamos el directorio `/etc/tuned/no-thp`

```bash
sudo mkdir /etc/tuned/no-thp
```

Creamos el archivo `/etc/tuned/no-thp/tuned.conf` con el siguiente contenido:

```ini
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
```

Habilitamos el profile

```bash
sudo tuned-adm profile no-thp
```

## Crear usuario de acceso

Duration: 5:00

Por seguridad debemos crear un usuario administrador:

```mongo
use admin
db.createUser(
  {
    user: "admin",
    pwd: "ADMIN_PASSWORD",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
```

Creamos un usuario de conexión para la aplicación

```
use BASE_DATOS
db.createUser(
  {
    user: "USUARIO_BASE",
    pwd: "PASSWORD_USUARIO",
    roles: [ { role: "readWrite", db: "BASE_DATOS" } ]
  }
)
```

> De ser necesario, se puede cambiar el *role* `readWrite` por `read` para un acceso de sólo lectura.

## Habilitar seguridad

Duration: 5:00

Por seguridad debemos habilitar la seguridad en MongoDB, para esto requerimos editar el archivo `/etc/mongod.conf` y agregar la sección *secyruty* (por default está comentada) de la siguiente forma:


```yaml
security:
  authorization: "enabled"
```

> En este archivo es muy importante el uso de espacios

Después se debe reiniciar el servicio:

```bash
sudo systemctl restart mongod
```

Prueba conexión:

```bash
mongo --port 27017 -u "USUARIO_BASE" -p "PASSWORD_USUARIO" --authenticationDatabase "BASE_DATOS"
```

> Se debe crear el usario previo a habilitar la seguridad.
