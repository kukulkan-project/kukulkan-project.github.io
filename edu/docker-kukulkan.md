author: Kukulkan Team
summary: Demo para utlizar Kukulkan
id: docker-kukulkan
categories: documentation
environments: js
status: draft
analytics account: 0

# Despliegue de un proyecto con DOCKERS

## Requerimientos

Duration: 15:00

Positive
: Para seguir este tutorial, se deberán de tener instalados los comandos `docker` y `docker-compose`.

Dependiendo del sistema operativo que se esté utlizando, se puede consultar la guía de instalación de `Docker` en alguno de los siguientes Links:

- [Instalar Docker para macOs](https://runnable.com/docker/install-docker-on-macos)
- [Instalar Docker para windos-10](https://runnable.com/docker/install-docker-on-linux)
- [Instalar Docker para windos-10](https://runnable.com/docker/install-docker-on-windows-10)

Para la instalación de `Docker Compose`, se puede seguir el siguiente link:

- [Instalar Docker Compose](https://docs.docker.com/compose/install/)

Para verificar que la instalación de `docker` se encuentra correcta, ejecute el siguiente comando

```bash
$ sudo docker run hello-world
```

## Descargar Archivo YAML
Duration: 3:00

A continuación, se va a utilizar una imagen `docker`, que ha sido construida a partir de un proyecto generado con la herramienta `kukulkan`, para levantar un servicio web. Para tal finalidad, deberá de guardar el contenido siguiente en un archivo llamado `app.yml`:

```yml
version: '2'
services:
    sfp-app:
        image: danimaniarqsoft/sfp:latest
        environment:
            - SPRING_PROFILES_ACTIVE=dev,swagger
            - APP_SLEEP=10
        ports:
            - 8080:8080
```

el archivo deberá de quedar en una ruta que le permita a ustede administrar sus imagenes docker; por ejemplo, `[HOME]/apps/docker/app.yml`

## Levantar Servicio
Duration: 2:00

A continuación, se deberá de cambiar a la carpeta en donde guardo el archivo `app.yml` y ejecutar el siguiente comando:

```bash
$ docker-compose -f app.yml up -d
```

En la consola, deberá de ver algo parecido a lo siguiente:

```console
sfp-app_1  |                                                  
sfp-app_1  |          ,---.           ,---.                   
sfp-app_1  |  ,---.  /  .-'  ,---.   /  O  \   ,---.   ,---.  
sfp-app_1  | (  .-'  |  `-, | .-. | |  .-.  | | .-. | | .-. | 
sfp-app_1  | .-'  `) |  .-' | '-' ' |  | |  | | '-' ' | '-' ' 
sfp-app_1  | `----'  `--'   |  |-'  `--' `--' |  |-'  |  |-'  
sfp-app_1  |                `--'              `--'    `--'    
sfp-app_1  | 
sfp-app_1  | 2018-10-26 17:37:13.139  INFO 1 --- [           main] mx.dads.infotec.SfpApp                   : Starting SfpApp on f1be0839403b with PID 1 (/app.war started by root in /)
sfp-app_1  | 2018-10-26 17:37:13.143 DEBUG 1 --- [           main] mx.dads.infotec.SfpApp                   : Running with Spring Boot v1.5.9.RELEASE, Spring v4.3.13.RELEASE
sfp-app_1  | 2018-10-26 17:37:13.144  INFO 1 --- [           main] mx.dads.infotec.SfpApp                   : The following profiles are active: dev,swagger
sfp-app_1  | 2018-10-26 17:37:13.460 DEBUG 1 --- [kground-preinit] org.jboss.logging                        : Logging Provider: org.jboss.logging.Slf4jLoggerProvider found via system property
sfp-app_1  | 2018-10-26 17:37:15.952 DEBUG 1 --- [           main] m.d.infotec.config.AsyncConfiguration    : Creating Async Task Executor
sfp-app_1  | 2018-10-26 17:37:16.766 DEBUG 1 --- [           main] c.ehcache.core.Ehcache-usersByLogin      : Initialize successful.
sfp-app_1  | 2018-10-26 17:37:16.780 DEBUG 1 --- [           main] c.ehcache.core.Ehcache-usersByEmail      : Initialize successful.
sfp-app_1  | 2018-10-26 17:37:16.956 DEBUG 1 --- [           main] m.d.infotec.config.MetricsConfiguration  : Registering JVM gauges
sfp-app_1  | 2018-10-26 17:37:16.973 DEBUG 1 --- [           main] m.d.infotec.config.MetricsConfiguration  : Monitoring the datasource
sfp-app_1  | 2018-10-26 17:37:16.973 DEBUG 1 --- [           main] m.d.infotec.config.MetricsConfiguration  : Initializing Metrics JMX reporting
sfp-app_1  | 2018-10-26 17:37:17.713 DEBUG 1 --- [           main] mx.dads.infotec.config.WebConfigurer     : Registering CORS filter
sfp-app_1  | 2018-10-26 17:37:17.856  INFO 1 --- [           main] mx.dads.infotec.config.WebConfigurer     : Web application configuration, using profiles: dev
sfp-app_1  | 2018-10-26 17:37:17.856 DEBUG 1 --- [           main] mx.dads.infotec.config.WebConfigurer     : Initializing Metrics registries
sfp-app_1  | 2018-10-26 17:37:17.859 DEBUG 1 --- [           main] mx.dads.infotec.config.WebConfigurer     : Registering Metrics Filter
sfp-app_1  | 2018-10-26 17:37:17.860 DEBUG 1 --- [           main] mx.dads.infotec.config.WebConfigurer     : Registering Metrics Servlet
sfp-app_1  | 2018-10-26 17:37:17.862 DEBUG 1 --- [           main] mx.dads.infotec.config.WebConfigurer     : Initialize H2 console
sfp-app_1  | 2018-10-26 17:37:17.862  INFO 1 --- [           main] mx.dads.infotec.config.WebConfigurer     : Web application fully configured
sfp-app_1  | 2018-10-26 17:37:18.625 DEBUG 1 --- [           main] m.d.i.config.DatabaseConfiguration       : Configuring Liquibase
sfp-app_1  | 2018-10-26 17:37:18.634  WARN 1 --- [ sfp-Executor-1] i.g.j.c.liquibase.AsyncSpringLiquibase   : Starting Liquibase asynchronously, your database might not be ready at startup!
sfp-app_1  | 2018-10-26 17:37:20.267 DEBUG 1 --- [ sfp-Executor-1] i.g.j.c.liquibase.AsyncSpringLiquibase   : Liquibase has updated your database in 1632 ms
sfp-app_1  | 2018-10-26 17:37:24.794 DEBUG 1 --- [           main] i.g.j.c.apidoc.SwaggerConfiguration      : Starting Swagger
sfp-app_1  | 2018-10-26 17:37:24.804 DEBUG 1 --- [           main] i.g.j.c.apidoc.SwaggerConfiguration      : Started Swagger in 9 ms
sfp-app_1  | 2018-10-26 17:37:26.051  INFO 1 --- [           main] mx.dads.infotec.SfpApp                   : Started SfpApp in 13.977 seconds (JVM running for 14.585)
sfp-app_1  | 2018-10-26 17:37:26.051  INFO 1 --- [           main] mx.dads.infotec.SfpApp                   : 
sfp-app_1  | ----------------------------------------------------------
sfp-app_1  | 	Application 'sfp' is running! Access URLs:
sfp-app_1  | 	Local: 		http://localhost:8080
sfp-app_1  | 	External: 	http://172.20.0.2:8080
sfp-app_1  | 	Profile(s): 	[dev, swagger]
sfp-app_1  | ----------------------------------------------------------
```

**Nota**: 
Para tener una mejor administración de sus servicios docker, revisar la documentación oficial en [Docker for beginners](https://docker-curriculum.com/)

## Visualización del Aplicativo
Duration: 1:00

El aplicativo se podrá consultar en la url [http://localhost:8080](http://localhost:8080) de manera local, en caso de que se encuentre el servidor publicando, entonces lo podrá hacer a través de la url [http:[IP_PUBLICA:8080]](http:[IP_PUBLICA:8080]). El resultado será el siguiente:

![Proyecto kukulkan](images/kukulkan-demo.png "Proyecto en Ejecución")

## Bajar el Servicio
Duration: 5:00


Para bajar el servicio que se ha levantado, se debe utilizar el siguiente comando:

```bash
$ docker-compose -f app.yml stop
```

Positive
: Para ejecutar el comando anterior, debe hacerlo en la ruta en donde se encuentra el archivo `app.yml`