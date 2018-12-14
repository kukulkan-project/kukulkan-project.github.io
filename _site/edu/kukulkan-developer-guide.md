author: Kukulkan Team
summary: Guía de Kukulkán para el desarrollador 
id: kukulkan-developer-guide
categories: demo
environments: js
status: draft
analytics account: 0

# Kukulkan Developer Guide

## Requerimientos

- [Kukulkan VS Code Extension](https://github.com/kukulkan-project/kukulkan-vscode-extension/releases)
- Kukulkan Shell (Instalador `.deb` o ejecutable `.exe`)
- Herramienta JPS (Añadir al PATH `{PATH_DE_JDK}/bin`)
- [Git](https://git-scm.com/downloads)

## Ejemplo de modelo de dominio

    //Se crea la entidad persona con 'usuarios' como nombre de la tabla en la base de datos
    entity Persona (usuarios) {
        -> nombre : String required min(3) max(50),
        edad : Integer min(5) max(120) required,
        sueldo : Long,
        impuesto : Float,
        activo : Boolean,
        fechaCreacion : LocalDate,
        foto : ImageBlob,
        ManyToOne manager : Persona,
        ManyToMany proyectos : Proyecto,
        OneToMany retardos : Retardo,
        OneToOne user: CoreUser
    }

    entity Proyecto {
        nombre : String required,
        descripcion : String
    }

    entity Retardo {
        descripcion : String,
        fecha : LocalDate
    }

    /**
    Cuando se usan vistas tipo 'Sheet' se requiere añadir el siguiente repositorio al pom.xml
    <repositories>
        <repository>
            <id>infotec-repo</id>
            <name>INFOTEC Repository</name>
            <url>http://artifactory.dads.infotec.mx/artifactory/infotec</url>
        </repository>
    </repositories>
    */
    views {
        Proyecto as Sheet
    }

## Kukulkan Shell

### Comandos básicos

- `help`: Display help about available commands.
- `clear`: Clear the shell screen
- `stacktrace`: Display the full stacktrace of the last error
- `stop-process`: Detiene un proceso Java

**Nota**: 
Kukulkan Shell cuenta con función de autocompletado de los comandos al presionar la tecla **TAB**. 
Por ejemplo, `sta` + `TAB` completará el comando `stacktrace` en la línea de comandos.

### Comandos de navegación

- `pwd`: Show the current direction
- `cd`: Change directory
- `dir`, `ll`, `ls`: List the currents files

## Generación de proyecto
    
    NAME
	    create-project - Generate a Project from an Archetype Catalog

    SYNOPSYS
	    create-project [--app-name] string  [--packaging] string  [[--database-type] database-type]  

    OPTIONS
	    --app-name  string
		
		    [Mandatory]
		    [no puede ser null]

	    --packaging  string
		
		    [Mandatory]
		    [no puede ser null]

	    --database-type  database-type
		
    		[Optional, default = NO_SQL_MONGODB]

Ejemplo:

    create-project --app-name demo  --packaging mx.infotec.dads.demo --database-type SQL_MYSQL
   
**Nota**: Si se encuentra **git** instalado se realizan las siguientes acciones luego de crear el nuevo proyecto: 
- Crea un nuevo repositorio
- Añade todos los archivos creados al *stage*
- Se hace un commit al repositoro
- Se crea la rama `develop` y se mueve hacia dicha rama

### Prompt
Cuando se navega a un directorio que contiene a la raíz de un proyecto generado con Kukulkán, el prompt se muestra diferente:
	
	kukulkan @app @git/develop

- `@app`: indica que el directorio contiene un proyecto generado con Kukulkán
- `@git/develop`: indica que el proyecto utiliza git como Software de Control de Versiones, seguido del nombre de la rama en que se encuentra el proyecto.

## Configuración del proyecto

    NAME
        config - Configurate the project

    SYNOPSYS
        config [[--type] configuration-type]  

    OPTIONS
        --type  configuration-type
            
            [Optional, default = FRONT_END]

Este comando es un *wrapper* de los siguientes comandos:
- `yarn install`: Instala las dependencias Node
- `bower install`: Instala las dependencias Bower
- `gulp`: Inyecta dependencias al `index.html`

## Ejecutando el proyecto

    NAME
	    run - Run a Spring-Boot App

    SYNOPSYS
	    run [[--profile] profile]  

    OPTIONS
	    --profile  profile
		
		    [Optional, default = DEV]

## Kukulkan DSL
El DSL de Kukulkan se utiliza para definir un modelo de dominio, con entidades y relaciones.

### Declaración de entidades

Sintaxis:

	entity <entity-name> [entity-table-name] {
		[<attribute-name> : <data-type> [<validator>*]
	}

#### Declarar una entidad sin atributos

	entity Person

#### Declarar una entidad con atributos

	entity Person {
		name: String required,
		lastName: String
	}

Todas las entidades contienen un atributo `id` por defecto.

Tipos de dato:
- String
- Integer
- Long
- BigDecimal
- Float
- Double
- Boolean
- Date
- LocalDate
- ZonedDateTime
- Instant
- Blob
- AnyBlob
- ImageBlob

## Relaciones

[Guía de relaciones con JPA](https://github.com/kukulkan-project/kukulkan-generator-angularjs/wiki/JPA-Relationships)

Sintaxis:

	entity <entity-name> (entity-table-name) {
		<relationship-type> [to-source-attribute-name] <attribute-name> : <entity>
	}

Tipos de relación:
- OneToOne
- OneToMany
- ManyToOne
- ManyToMany

### Relación Unidireccional

	entity Person {
		name: String,
		OneToOne address: Address
	}
	entity Address {
		street: String
	}

### Relación Bidireccional

	entity Person {
		name: String,
		OneToOne (person) address: Address
	}
	entity Address {
		street: String required
	}

Nótese que en las relaciones bidireccionales se define un elemento extra `(person)`, esto significa que:
- en la entidad `Person` se creará un atributo del tipo `Address`.
- en la entidad `Address` se creará un atributo del tipo `Person`. 

### Display field
El **display field** es el atributo de la entidad que se muestra en la interfaz gráfica cuando es referenciada mediante una relación con otra entidad. Por defecto es el atributo `id` pero se puede cambiar usando el símbolo de flecha `->` en la declaración de la entidad. Por ejemplo: 

	entity Person {
		name: String,
		OneToOne address: Address
	}
	entity Address {
		-> street: String required
	}

Se usará `street`, en lugar de `id`, como **display field** en el formulario de creación/edición de la entidad Person. 

### Relación con CoreUser
En el DSL de Kukulkan, `CoreUser` es una palabra reservada para representar a la entidad `User` que se crea junto con el arquetipo. Esta entidad se puede asociar con cualquier otra definida por el usuario pero solo tiene soporte para los tipos de relación unidireccional `OneToOne`, `ManyToOne` y `ManyToMany`. Por ejemplo:

	entity Person {
		OneToOne user: CoreUser
	}

Nótese que no es necesario declarar ni importar a `CoreUser` en el modelo de dominio. 

## Generación de CRUD

    NAME
        add-entities-from-language - Generate all the entities that come from a file with .3k or .kukulkan extension

    SYNOPSYS
        add-entities-from-language [--file-name] string  [[--exclude-layers] string]  

    OPTIONS
        --file-name  string
            
            [Mandatory]

        --exclude-layers  string
            
            [Optional, default = @all]
**Nota**:
Luego de la adición de entidades al proyecto Kukulkán Shell ejecuta el comando `config --type FRONT_END` para asegurarse que los archivos generados en el *front-end* sean inyectados al `index.html`, entre otras acciones. 

### Cliente (Front-end, AngularJS)

| Archivo                                  | Descripción                                                             |
|:-----------------------------------------|:------------------------------------------------------------------------|
| app/entities/person/person.service.js    | Este servicio consume la API REST del servidor                          |
| app/entities/person/person.controller.js | Controlador: está enlazado a la vista                                   |
| app/entities/person/persons.html         | Vista: Muestra todas las personas existentes                            |
| app/entities/person/person.state.js      | Estado (o ruta): Define el estado 'person' y la url de la vista         |
  

### Servidor (Back-end, Spring Boot)


| Clase                                               | Descripción                                                             |
|:----------------------------------------------------|:------------------------------------------------------------------------|
| mx.infotec.dads.demo.domain.Person                  | Entidad de dominio (POJO)                                               |
| mx.infotec.dads.demo.repository.PersonRepository    | Aquí van los queries a la BD                                            |
| mx.infotec.dads.demo.service.PersonService          | Aquí se definen los métodos del servicio                                |
| mx.infotec.dads.demo.service.impl.PersonServiceImpl | Implementación de la interfaz PersonService (utiliza a PersonRepository)|
| mx.infotec.dads.demo.web.rest.PersonResource        | Servicio REST (utiliza a PersonService)                                 |

## Recorrido por el arquetipo

### Front-end AngularJS
[Estructura del proyecto](https://github.com/kukulkan-project/kukulkan-generator-angularjs/wiki/Arquitectura-AngularJs)

### Back-end Spring Boot

## Administración de usuarios desde consola
Cuando se crea una aplicación que usa el arquetipo de JPA, se crean tres archivos con los que se cargan usuarios y roles a la base de datos con Liquibase:

- `src/main/resources/config/liquibase/users.csv`: usuarios
- `src/main/resources/config/liquibase/authorities.csv`: roles
- `src/main/resources/config/liquibase/users_authorities.csv`: relaciona usuarios con roles

Kukulkán Shell proporciona algunos comandos para administrar usuarios y roles sin tener que ejecutar la aplicación.

### Comandos para la administración de usuarios:  
- `list-users`: lista los usuarios registrados
- `add-user`: añade un usuario
- `update-user`: actualiza un usuario
- `delete-user`: elimina un usuario

#### Ejemplo:
Añadir un usuario:  
`add-user --first-name Kukulkan --last-name Kukulkan --email kukulkan@example.com --login kukulkan --authorities ROLE_ADMIN --password 1234`

Modificar el password de un usuario:  
`update-user  --id 5 --password kukulkan`

Eliminar un usuario:   
`delete-user --id 5`

### Comandos para la administración de roles:
- `list-authorities`: lista todos los roles
- `add-authority`: añade un rol
- `add-authority-to-user`: añade un rol a un usuario
- `delete-authority`: elimina un rol

#### Ejemplo:
Añadir un rol:  
`add-authority --name ROLE_SUPERVISOR`

Añadir un rol a un usuario:  
`add-authority-to-user --authority-name ROLE_SUPERVISOR --user-id 3`

Eliminar un rol:  
`delete-authority --name ROLE_SUPERVISOR`

## Despliegue en Heroku
Actualmente solo se cuenta con soporte para desplegar una aplicación en Heroku que no requiera una base de datos física, es decir que utilice una base de datos en memoria.  

Existen dos comandos para Heroku:
- `add-heroku-support`: para añadir soporte para desplegar la aplicación en Heroku
- `deploy-to-heroku`: para desplegar la aplicación en Heroku

### Requisitos
- Instalar [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
- Instalar Heroku CLI Deploy: `heroku plugins:install heroku-cli-deploy`

### Añadir soporte para Heroku
```
NAME
	add-heroku-support - Add Heroku support to project

SYNOPSYS
	add-heroku-support [--deploy]  [[--heroku-app-name] string]  

OPTIONS
	--deploy	
		[Mandatory]

	--heroku-app-name  string
		
		[Optional, default = ]
```

#### Ejemplos:
Añadir soporte para Heroku. Intentar crear la aplicación en Heroku con un nombre generado a partir del nombre de mi proyecto. Si el nombre generado no está disponible entonces Heroku generará uno aleatoriamente.  
`add-heroku-support`

Añadir soporte para Heroku con el nombre _my-kukulkan-app_  
`add-heroku-support --heroku-app-name my-kukulkan-app`

Añadir soporte para Heroku con el nombre _my-kukulkan-app_ y luego desplegar  
`add-heroku-support --heroku-app-name my-kukulkan-app --deploy`

### Desplegar en Heroku
```
NAME
	deploy-to-heroku - Deploy project to Heroku

SYNOPSYS
	deploy-to-heroku
```