author: Kukulkan Team
summary: Demo para utlizar Kukulkan
id: git-guideline-kukulkan
categories: documentation
environments: js
status: draft
analytics account: 0

# Lineamientos para Git

## Introducción

Los lineamietos expuestos aquí son una extensión de [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model)

Explicar el modelo de desarrollo y control de versión de código de los sistemas desarrollados utiliando la plataforma **kukulkan**

El modelo de desarrollo explicado aquí puede variar de acuerdo a las necesidades específicas de cada proyecto, sin embargo el modelo general de desarrollo considera diferentes flujos trabajo que pueden adaptarse a las necesidades específicas. El modelo definido aquí aplica sólo para equipos que se encuentren gestionando su código con la herramienta **Git**.

## Elementos del Flujo de Desarrollo

El flujo de trabajo consta de la definición de los siguientes elementos:

1. Roles
2. Actividades
3. Ramas principales

### Roles

El modelo de desarrollo involucra dos roles; **Master** y **Developer**, mismos que se describen a continuación:

**Master**

> Principalmente, este rol será el encargo de llevar a cabo la integración del sistema, además de las siguientes responsabilidades:
>
> 1. Llevar a cabo las operaciones de integración entre la rama origin/develop y origin/master.
> 2. Verificar que los números de versiones en la rama master respetan el versionamiento [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).
> 3. Identificar inconsistencias entre la nueva versión y anteriores.

**Developer**

> En cada proyecto se puede contar con 1 o más roles de este tipo y sus principales actividades son:
>
> 1. Participar en la construcción de nuevas funcionalidades sobre un sistema de software.
>
> 2. Construir software de calidad de acuerdo a los estándares definidos en la organización.
>
> 3. Participar en las tareas de integración cuando estas sean solicitadas por el rol master.

### Actividades

Las actividades que se llevan a cabo en el modelo de desarrollo se ilustran en la siguiente gráfica:

![](images/diagram.png)

#### Ramas Principales

## Meta Información para cada Rama

Con la finalidad de comprender de manera precisa el estudio de las diferentes ramas de trabajo utilizados en la **DADS**, a continuación se presenta la descripción de la meta-información que define a cada una de las ramas y que será utilizado a lo largo de este documento para describirla.

| Metadato | Descripción |
| --- | --- |
| Descripción | Descripción básica de la rama en cuestión. |
| Rama de la que bifurca | Nombre de la rama que bifurcó. |
| Rama con la que se une | Nombre de la rama a la que se une cuando se ejecuta una operación de tipo merge. |
| Convención de nombrado | Convención de nombrado que aplica para la rama. |
| Lineamiento | Consideraciones para el buen uso de la Rama. |
| Diagrama | Diagrama explicativo sobre el uso de la rama. |
| Comandos | Comandos sugeridos para la creación, modificación, unión y eliminación de la rama. |

## Rama Master

### Descripción

La rama **master**, por convención, será la rama principal del proyecto. En esta rama se encuentran las versiones productivas del sistema y que se han liberado a producción.

### Rama de la que bifurca

`Ninguna`

### Rama con la que se une

`Ninguna`

### Convención de nombrado

Esta rama **siempre** se llama `master`

### Lineamientos

1. No está permitido subir “código roto” a la rama master.
2. El código que se suba a master deberá de ser cuidadosamente probado antes de ser integrado; se sugiere utilizar el branch _release_ antes de que una nueva liberación se lleve a cabo a la rama **master**.
3. Sólo el **rol master** puede ejecutar la operación de `push/merge` a esta rama.
4. Esta rama **nunca** se deberá de borrar.

### Diagrama

![](images/branch-develop.png)

### Comandos

`[NO APLICA]`

## Rama Develop

### Descripción

La rama **develop**, por convención, será la rama secundaria del proyecto. En esta rama, el equipo de desarrollo se encuentra trabajando día con día una nueva versión del sistema.

### Rama de la que bifurca

`master`

### Rama con la que se une

`master`

### Convención de nombrado

Siempre se llamará `develop`

### Lineamientos

### Diagrama

![](images/branch-develop.png)

### Comandos

`[NO APLICA]`

## Rama Feature

### Descripción

La rama de características “**feature**” es utilizada para desarrollar nuevas características o funcionalidades que vendrán en las próximas o futuras entregas. Esta rama se crea cuando se comienza a desarrollar una nueva característica de la cual se desconoce la fecha de entrega. La esencia de esta rama es que exista durante el periodo de tiempo en que tome desarrollar la nueva característica. Eventualmente, esta rama se unirá a la rama de desarrollo **develop** \(para agregar de manera definitiva la nueva característica en la próxima entrega\) o se eliminará \(en caso de que la nueva característica no cumpla con los objetivos deseados\).

### Rama de la que bifurca

`develop`

### Rama con la que se une

`develop`

### Convención de nombrado

El nombrado de esta rama se deberá de apegar a lo establecido en \[AGIS\] y la propuesta en esta sección:

Nomenclatura Adicional:`feature-*`

Ejemplo:

* feature-seguridad
* feature-carrusel

### Lineamientos

1. Sólo existe en el repositorio local, nunca en el remoto **origin**

### Diagrama

![](images/branch-features.png)

### Comandos

Crear una rama `feature` a partir de la rama `develop` se deberá de hacer lo siguiente:

```bash
git checkout -b feature-seguridad develop
```

Una vez que se a trabajo en la nueva rama, para actualizar los cambios en la rama `develop` primero tenemos que regresar a la rama `develop` y partir de allí llevar a cabo la operación `merge`:

```bash
git checkout develop
```

Unir las modificaciones hechas en la rama `feature` dentro de la rama `develop`:

```bash
git merge --no-ff feature-seguridad
```

A continuación, se deberá de borrar la rama `feature-seguridad`:

```bash
git branch -d feature-seguridad
```

Finalmente, se envian los cambios a la rama remota `develop`

```bash
git push origin develop
```

## Rama Release

### Descripción

La rama “**release**” se debe utilizar para la preparación de una nueva entrega en el ambiente de producción. Esta rama es útil para corregir pequeños defectos y preparar los metadatos que deberá llevar la próxima entrega \(número de versión, fecha de compilación, etc.\). El beneficio de tener una rama de entrega **release** radica en el hecho de que podemos conservar la rama **develop** limpia y lista para recibir nuevas versiones que se tendrán que integrar a la rama **master**. Adicionalmente, la rama **release** será utilizada por el equipo de **QA** para probar la entrega antes de que esta llegue a producción.

### Rama de la que bifurca

`develop`

### Rama con la que se une

* `develop`
* `master`

### Convención de nombrado

El nombrado de esta rama se deberá de apegar a lo establecido en \[AGIS\] y la propuesta en esta sección:

Nomenclatura obligatoria: `release-*`

Ejemplo:

* `release-seguridad`
* `release-carrusel`

### Lineamientos

1. El mejor momento para crear una ramificación de develop es cuando el desarrollo refleja el estado deseado de una nueva entrega.

2. Todas las funcionalidades o características que se esperan mostrar en la próxima entrega deberán de unirse a la rama de develop.

3. Es exactamente al comienzo de la creación de esta rama en que se asigna una versión. Es hasta ese momento que la rama develop refleja los cambios para la siguiente entrega, pero no es claro si esa nueva entrega eventualmente se convertirá en la versión 0.3 o 1.0. La notación para el versionamiento de código es la descrita en [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html)

### Diagrama

![](images/branch-hotfixes.png)

### Comandos

Creación de la rama de entrega `release-1.2`

```bash
git checkout -b release-1.2 develop
```

Una vez que se a trabajo en la nueva rama, para actualizar los cambios en la rama develop primero tenemos que regresar a la rama develop y partir de allí llevar a cabo una unión \(merge\):

```bash
./bump-version.sh 1.2
```

Unir las modificaciones hechas en la rama feature dentro de la rama develop:

```bash
git commit -a -m "Bumped version number to 1.2"
```

Cambiarnos a la rama de master:

```bash
git checkout master
```

Unir los cambios de la rama release1.2 con master:

```bash
git merge –no-ff release-1.2
```

Enviar los cambios a la rama develop

```bash
git tag –a 1.2
```

## Rama Hotfixes

### Descripción

Una vez que se ha llevado a cabo una liberación a la rama `master` y esta versión forma parte del ambiente productivo del cliente, es posible que exista el reporte de nuevos `bugs` encontrados por los usuarios finales. Para corregir estos `bugs` y desplegar una nueva versión en el ambiente productivo, es que se utilizará la rama `hotfixe`, que ayudará a corregir errores que surgan en el ambiente de producción.

### Rama de la que bifurca

`master`

### Rama con la que se une

`master`
`develop`

### Convención de nombrado

hotfix-\[modulo-version\]

Ejemplo:

* `hotfix-seguridad-v1.1.1`
* `hotfix-carrusel-v1.1.1`

### Lineamientos

1. La rama `hotfixes` sólo existe mientras se está corriguiendo errores.
2. La rama `hotfixes` existe en el repositorio remoto.
3. La rama `hotfixes` es creada y eliminada por el rol master.
4. La operación **merge** con la rama `master` y la rama`develop` sólo la pude llevar a cabo el **rol master**.

Si existe una rama release cuando ocurre un bug en producción, entonces:

1. Los **bugs** corregidos en la rama `hotfix` se deberán de unir a la rama `release` y no a `develop`; la unión con `develop` ocurre cuando la rama `release` está lista para producción. Si el trabajo en la rama `develop` requiere de manera inmediata el cambio realizado en la rama `hotfix`, entonces se puede lleva a cabo la operación **merge** dentro de la rama `develop`;

### Diagrama

![](images/branch-hotfixes.png)

### Comandos

### Crear una rama `hotfix`

Las ramas hotfix son creados desde la rama master. Por ejemplo, si la versión que se liberó a producción fue la `1.2.0`, y se detectan errores durante el uso del sistema y los cambios en la rama `develop` no son estables, entonces se pude crear una rama `hotfix` para atender los bugs y volver a liberar a producción.

```bash
git checkout -b hotfix-1.2.1 master
./bum-version.sh 1.2.1
git commit -a -m "Versión modificada a 1.2.1"
```

Durante este paso se deberán de corregir los `bugs` en uno o varios `commits`:

```bash
git commit -m "Resolviendo bugs de producción"
```

Finalmente, se lleva a cabo un `merge` tanto a la rama `master` como a la rama `develop`,

Operación `merge` en la rama `master`:

```bash
git checkout master
git merge --no-ff hotfix-1.2.1
```

**Nota** Se puden utilizar las opciones`-s` o `-u` para firmar nuestro tag.

Operación `merge` en la rama `develop`:

```bash
git checkout develop
git merge --no-ff hotfix-1.2.1
```

**Nota** en caso que exista una rama de `release` los cambios en la rama `hotfix` deberán de unirse también en la rama `release`, en lugar de `develop`.

Eliminación de la rama temporal:

```bash
git branch -d hotfix-1.2.1
```

## Lineamientos Generales

En general, siempre hay que considerar los siguientes elementos:

* Para comenzar a trabajar siempre hay que crear un branch a partir de origin develop.
* Probar el software antes de hacer un push al repositorio remoto **origin develp**.
* En caso que esté trabajando en una nueva funcionalidad y decides que no formará parte de la rama develop, entonces, para comenzar a trabajar sobre otra nueva funcionalidad siempre deberás de hacer un rebase a **develop**.
* Llevar a cabo la operación checkout a develop, para asegurarte que te encuentras trabajando con la última versión del proyecto en fase de desarrollo.
* Siempre prueba tu código una y otra vez.
* Los proyectos no deberán de ser creados por los integrantes del repositorio gitlab, únicamente el administrador será el único facultado en llevar a cabo este tipo de acciones.

## Lineamientos Particulares

Los siguiente lineamientos aplican a todas la ramas:

* Tanto el nombre de los directorios, como el de los productos de trabajo que están contenidos en ellos no incluirán acentos, ni caracteres especiales, ni espacios.
* El código contenido en cualquier rama deberá ser versionado haciendo uso del juego de caracteres **UTF-8**.
* Salvo imágenes, las ramas sólo podrán contener código fuente. Ningún otro archivo de tipo binario deberá ser considerado para versionamiento en la rama de código. En caso que sea necesario subir imágenes, estas deberán de ser codificadas en **base64**.
* Efectuar el **push** sólo para las unidades funcionales completas.
* Efectuar **push** de manera frecuente. De ser posible, cada día, siempre y cuando esto no entre en conflicto con la regla anterior.
* Para **push** deberá generarse un comentario amplio y descriptivo que incluya el detalle de aquello que se está subiendo en el repositorio **Git**.
* Generar respaldos de la base de datos **Git** en una base mensual.
* No estará permitido efectuar bloqueos, a menos que esto sea justificado plenamente.

## Notas Importantes

Existen dos cosas que nunca se deberá de llevar a cabo en **Git**:

1. **NUNCA** forzar una operación **push**: Si te encuentras en una situación donde tus cambios no puedas ser enviados al upstream, debido a que algo está mal.

2. **NUNCA** ejecutes la operación **rebase** a una rama a la que le has aplicado la operación **push** o **pull**. Esto puede generar la duplicidad de **_commits_** a un repositorio compartido.
