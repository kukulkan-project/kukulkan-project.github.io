author: Kukulkan Team
summary: Instalación de Java 8 en Centos 7
id: install-java8-on-centos
categories: instalacion
environments: js
status: draft
analytics account: 0

# Instalación de Java 8 en Centos 7

## Prerequisitos

Duration: 1:00

1. Centos 7 64Bits
2. Acceso como *superusuario*
3. Acceso remoto por medio de *ssh*

## Actualización de paquetes

Duration: 5:00

```bash
sudo yum -y update
sudo yum -y install wget emacs-nox vim
```

## Corrección del *locale*

Duration: 3:00

En caso de que al acceder por *ssh* a la máquina virtual marque un error con el *locale*, se puede corregir agregando dos líneas al archivo `/etc/locale.conf`

```ini
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
```

Positive
: Dependiendo del idioma de instalación, puede que lo más correcto sea `LANG=es_MX.UTF-8` y `LC_ALL=es_MX.UTF-8`.

## Instalación de Java

Duration: 5:00

Descargar el *rpm* de Java desde la página de Oracle

```bash
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm"
sudo yum localinstall -y jdk-8u151-linux-x64.rpm
rm -f jdk-8u151-linux-x64.rpm
```

Negative
: *Nota:* Es probable que la versión de Java cambien y el *link* no funcione en un futuro, por lo que se deberá de verificar la validez del *link*

## Revisión de ligas

Duration: 5:00

Verificar que las existen dos ligas en `/usr/java`, con el siguiente comando:

```bash
ll /usr/java/
```

Debería salir algo como lo siguiente:

```bash
[root@localhost ~]# ll /usr/java/
total 0
lrwxrwxrwx. 1 root root  16 oct 30 16:10 default -> /usr/java/latest
drwxr-xr-x. 9 root root 268 oct 30 16:10 jdk1.8.0_151
lrwxrwxrwx. 1 root root  22 oct 30 16:10 latest -> /usr/java/jdk1.8.0_151
```

## Corrección de *alternatives*

Duration: 5:00

Verificar que tanto `java` como `javac` apunten a la versión Java de Oracle recien instalada, se ejecutan los siguientes comandos:

```bash
java -version
```

Debería salir:

```bash
[root@localhost ~]# java -version
java version "1.8.0_151"
Java(TM) SE Runtime Environment (build 1.8.0_151-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.151-b12, mixed mode)
```

```bash
javac -version
```

Debería salir:

```
[root@localhost ~]# javac -version
javac 1.8.0_151
```

En caso contrario se deberá corregir por medio del comando `alternatives`.

## Corrección de `java`

Duration: 5:00

```bash
sudo alternatives --config java
```

saldrá un menú como el siguiente:

```
Hay 2 programas que proporcionan 'java'.

  Selección    Comando
-----------------------------------------------
   1           /usr/java/jdk1.8.0_151/jre/bin/java
*+ 2           java-1.8.0-openjdk.x86_64 (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.x86_64/jre/bin/java)

Presione Intro para mantener la selección actual[+], o escriba el número de la selección: 1
```

> En este caso se pone 1 y se presiona `enter`.

## Corrección de `javac`

Duration: 5:00

```bash
sudo alternatives --config javac
```

saldrá un menú como el siguiente:

```
Hay 2 programas que proporcionan 'java'.

  Selección    Comando
-----------------------------------------------
*+ 1           /usr/java/jdk1.8.0_151/bin/javac

Presione Intro para mantener la selección actual[+], o escriba el número de la selección: 1
```

> En este caso se pone 1 y se presiona `enter`.
