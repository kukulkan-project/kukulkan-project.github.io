author: Kukulkan Team
summary: Lineamientos para Servicios REST Full
id: rest-guideline-kukulkan
categories: lineamientos
environments: js
status: draft
analytics account: 0

# Lineamientos para la Construcción de Servicios RESTful

## Utilizar sustantivos en plural y sin verbos

Positive
: Usar:
```
/carros
/carros/711
```

Negative
: No Usar
```
/getAllCars
/createNewCar
/deleteAllCars
```

## El método GET no debe alterar el estado del recurso

Utillizar los métodos `PUT`, `POST` y `DELETE` en lugar del método `GET` para alterar el estado de un recurso.

Positive
: Usar:
```
PUT /usuario/711?activate
PUT /usuario/711/activate
```

Negative
: No Usar:
```
GET /users/711?activate
GET /usuario/711/activate
```

## Utilizar sustantivos en plural

No mezclar sustantivos en singular y en plural. Utilizar sólo plural para todos los recursos.


Positive
: Usar
```
/cars
/users
/products
/settings
```

Negative
: No Usar
```
/car
/user
/product
/setting
```

## Utilizar sub-recursos para relaciones 

Si un recurso está relacionado con otro, utilizar notación para sub-recursos:

```
GET /cars/711/drivers/ Regresa una lista de drivers para el carro 711 
GET /cars/711/drivers/4 regresa un driver #4 para el carro 711
```

## Utilizar HTTP Headers para los formatos de serialización

Positive
: Tanto el cliente como el servidor necesitan saber que tipo de formato se está utilizando durante la comunicación. El formato tiene que ser especificado en el header del protocolo HTTP:

`Content-Type` define el formato de la solucitud.  

`Accept` define una lista de formatos de respuesta aceptables.

## Utilizar HATEOAS (Opcional)

HATEOAS (**H**ypermedia **a**s **t**he **E**ngine of **A**pplication **S**tate) deberá de ser utilizado para crear una mejor navegación a través del **API**

```json
{
  "id": 711,
  "manufacturer": "bmw",
  "model": "X5",
  "seats": 5,
  "drivers": [
   {
    "id": "23",
    "name": "Stefan Jauker",
    "links": [
     {
     "rel": "self",
     "href": "/api/v1/drivers/23"
    }
   ]
  }
 ]
}
```

## Proveer Filtrado de Información

Positive
: Proveer operaciones de filtrado (filtering),  ordenamiento (sorting), selección de campos (field selection) y Paginación (Paging) de colecciones

### Filtering

Utilizar sólo un parámetro de busqueda por cada campo que se desea filtrar:

```
GET /cars?color=red Regresa una lista de todos los carros Rojos
GET /cars?seats<=2 Regresa una lista de los carros que tienen un máximo de 2 asientos
```

### Sorting

Similar a `filtering`, en `Sorting` se utiliza un parámetro genérico llamdo **sort** que puede ser utilizado para describir reglas de ordenamiento; generalmente el ordenamiento es de tipo ascendente o descendente sobre varios campos separados por comas:

```shell
# Recupera los carros ordenamos de manera ascendente en el campo id
GET /cars?sort=id,asc

La consulta anterior regresará una lista de carros ordenados de manera ascendente en el campo id y de manera ascendente en el campo modelo.

# Recuepera todos los tickets en orden descendiente en el campo id.
GET /tickets?sort=id,desc
```

### Field Selection

Dar la posibilidad de elegir los campos que se desean regresar. Esto ayuda a reducir el tráfico en la red.

Ejemplo:

```
# Para la entidad Car
GET /cars?fields=manufacturer,model,id,color

# Para la entidad Tickets
GET /tickets?fields=id,subject,customer_name,updated_at&state=open&sort=-updated_at
```

### Paging

Utilizar la propiedad `page` y `size` para limitar el número de resultados que se desean recuperar.

Ejemplo:

```
GET /cars?page=0&size=5
```

Los links para las páginas siguientes, o previas, deberán de ser provista en el json que se regresa. Para la navegación a través del API deberá de ser a través de las siguientes propiedades:

```javascript
last : true o false
totalElements : Número de elementos en la base de datos
totalPages : Número de páginas que pueden mostrar para un determinado tamaño
first : true si el resultado es la primer página de la colección
numberOfElements : Número de elementos que se tiene en la página actual
sort : true Sí los valores están ordenados 
size : Tamaño de elementos que se muestran por ágina
number : Número de la página
```

Un ejemplo de la respuesta se muestra a continuación:

Solicitud:

```bash
curl -u dads:dads http://localhost:8080/rest-spring-jpa/dataStores?page=3\&size=2
```

Respuesta:

```javascript
{
  "content": [
    {
      "id": 1,
      "dataStoreType": {
        "id": 1,
        "name": "jdbc",
        "description": "Data Store for JDBC connector"
      },
      "url": "jdbc:mysql://localhost/membership?autoReconnect=true",
      "driverClass": "com.mysql.jdbc.Driver",
      "username": "developer",
      "password": "temporal123",
      "tableTypes": "TABLE,VIEW"
    }
  ],
  "last": true,
  "totalElements": 1,
  "totalPages": 1,
  "first": true,
  "numberOfElements": 1,
  "sort": null,
  "size": 1,
  "number": 0
}
```

## Versión del API

Positive
: Se deberá de versionar el **API** y no se deberá de liberar ninguna **API** sin versión. Para la versión de un API Restful existen dos alternativa; versión en la url y versión en el header del protocolo HTTP. Cualquiera de los casos se deberá de justificar el enfoque adquirido.

## Manejar los errores con los estados del protocolo HTTP

El estándar HTTP provee al rededor de 70 códigos para estados que describen los valores que regresan.

```javascript
200 – OK – Eyerything is working
201 – OK – New resource has been created
204 – OK – The resource was successfully deleted

304 – Not Modified – The client can use cached data

400 – Bad Request – The request was invalid or cannot be served. The exact error should be explained in the error payload. E.g. „The JSON is not valid“
401 – Unauthorized – The request requires an user authentication
403 – Forbidden – The server understood the request, but is refusing it or the access is not allowed.
404 – Not found – There is no resource behind the URI.
422 – Unprocessable Entity – Should be used if the server cannot process the enitity, e.g. if an image cannot be formatted or mandatory fields are missing in the payload.

500 – Internal Server Error – API developers should avoid this error. If an error occurs in the global catch blog, the stracktrace should be logged and not returned as response.
```

Se tiene que considerar el [payload](http://softwareengineering.stackexchange.com/questions/158603/what-does-the-term-payload-mean-in-programming) que se tiene que pagar para manejar de manera adecuada los mensajes anteriores en una respuesta json. Por ejemplo, el cliente del `API` deberá de saber como manejar una respuesta como la siguiete:

```javascript
{
  "errors": [
   {
    "userMessage": "Disculpa, el recurso solicitado no existe",
    "internalMessage": "El usuario no existe en la base de datos",
    "code": 34,
    "more info": "http://dads.infotec.mx/app/api/v1/errors/12345"
   }
  ]
}
```

## Permitir sobreescribir los métodos HTTP

Positive
: Algunos proxies sólo permiten métodos `POST` y `GET`. Para soportar una `API` de tipo RESTful se deberá de enviar la información utilizando la directiva `X-HTTP-Method-Override` del método POST y en el Header del protocolo HTTP.

## Actualizaciones y creaciones deberá de regresar una representación del Recurso

Los métodos `PUT`, `POST` o `PATCH` pueden llevar a cabo modificaciones a los campos de un recurso, por lo tanto deberán de indicar, como parte de la respuesta, sí la operación fue de actualización (updated) o creación (created).

En el caso de una petición `POST` que resulte en una creación, se deberá de utilizar el `HTTP 201 status code` e incluir un `Location Header` que contenga una URL con el nuevo recurso.

## Ejemplo CRUD de la Entidad Carro

**RESOURCE**:
```
http://dads.infotec.mx/app/api/v1/carros
```
#### Operaciones CRUD
**POST** (create)
```
crea un nuevo carro
```
**GET** (read)
```
consulta la lista de carros disponibles
```
**PUT** (update)
```
actualiza uno o varios carros
```
**DELETE** (delete)
```
borra todos los carros disponibles
```

## Otros Ejemplos

A continuación, se muestran más ejemplos de peticiones HTTP utilizando los lineamientos vistos hasta el momento:


| HTTP Método | Resource Endpoint | input                       | Success Response                        | Error Response    |
|:-----------:|:-----------------:|-----------------------------|-----------------------------------------|-------------------|
| **GET**         | /polls            | Body:Empty                  | Status: 200  Body:Poll List             | Status: 500       |
| **POST**        | /polls            | Body:New Poll data          | Status:201  Body: Newly created poll id | Status: 500       |
| **PUT**         | /polls            | N/A                         | N/A                                     | Status: 400       |
| **DELETE**      | /polls            | N/A                         | N/A                                     | Status: 400       |
| **GET**         | /polls/{pollId}   | Body:Empty                  | Status: 200  Body: Poll data            | Status: 400 o 500 |
| **POST**        | /polls/{pollId}   | N/A                         | N/A                                     | Status: 400       |
| **PUT**         | /polls/{pollId}   | Body:Poll data with Updates | Status:200  Body:Empty                  | Status: 404 o 500 |
| **DELETE**      | /polls/{pollId}   | Body:Empty                  | Status:200                              | Status: 404 o 500 |

## Ejemplo de Implementación utilizando Java y Spring

Entidad : DataStore

Consultar todos los **DataStore**:

```java
    /**
     * GET /data-stores : get all the dataStores.
     *
     * @param pageable
     *            the pagination information
     * @return the ResponseEntity with status 200 (OK) and the list of
     *         dataStores in body
     */
    @GetMapping("/data-stores")
    @Timed
    public ResponseEntity<List<DataStore>> getAllDataStores(@ApiParam Pageable pageable) {
        log.debug("REST request to get a page of DataStores");
        Page<DataStore> page = dataStoreService.findAll(pageable);
        HttpHeaders headers = PaginationUtil.generatePaginationHttpHeaders(page, "/api/data-stores");
        return new ResponseEntity<>(page.getContent(), headers, HttpStatus.OK);
    }
```

Para consultar un elemento por su identificador

```java
    /**
     * GET /data-stores/:id : get the "id" dataStore.
     *
     * @param id
     *            the id of the dataStore to retrieve
     * @return the ResponseEntity with status 200 (OK) and with body the
     *         dataStore, or with status 404 (Not Found)
     */
    @GetMapping("/data-stores/{id}")
    @Timed
    public ResponseEntity<DataStore> getDataStore(@PathVariable String id) {
        log.debug("REST request to get DataStore : {}", id);
        DataStore dataStore = dataStoreService.findOne(id);
        return ResponseUtil.wrapOrNotFound(Optional.ofNullable(dataStore));
    }
```

Para crear una nueva entidad de tipo **DataStore**

```java
    /**
     * POST /data-stores : Create a new dataStore.
     *
     * @param dataStore
     *            the dataStore to create
     * @return the ResponseEntity with status 201 (Created) and with body the
     *         new dataStore, or with status 400 (Bad Request) if the dataStore
     *         has already an ID
     * @throws URISyntaxException
     *             if the Location URI syntax is incorrect
     */
    @PostMapping("/data-stores/test")
    @Timed
    public ResponseEntity<DataStore> testConnection(@Valid @RequestBody DataStore dataStore) throws URISyntaxException {
        log.info("REST connection DataStore : {}", dataStore);
        if (dataStoreService.testConnection(dataStore)) {
            return ResponseEntity.ok().headers(HeaderUtil.createSuccessDataStoreStatus(ENTITY_NAME, "ok"))
                    .body(dataStore);
        } else {
            return ResponseEntity.badRequest()
                    .headers(HeaderUtil.createFailureDataStoreStatus(ENTITY_NAME, "failure"))
                    .body(dataStore);
        }
    }

```

Para actualizar un elemento de tipo **DataStore**

```java
    /**
     * PUT /data-stores : Updates an existing dataStore.
     *
     * @param dataStore
     *            the dataStore to update
     * @return the ResponseEntity with status 200 (OK) and with body the updated
     *         dataStore, or with status 400 (Bad Request) if the dataStore is
     *         not valid, or with status 500 (Internal Server Error) if the
     *         dataStore couldnt be updated
     * @throws URISyntaxException
     *             if the Location URI syntax is incorrect
     */
    @PutMapping("/data-stores")
    @Timed
    public ResponseEntity<DataStore> updateDataStore(@Valid @RequestBody DataStore dataStore)
            throws URISyntaxException {
        log.debug("REST request to update DataStore : {}", dataStore);
        if (dataStore.getId() == null) {
            return createDataStore(dataStore);
        }
        DataStore result = dataStoreService.save(dataStore);
        return ResponseEntity.ok()
                .headers(HeaderUtil.createEntityUpdateAlert(ENTITY_NAME, dataStore.getId().toString())).body(result);
    }
```

Para borrar un recurso:

```java
    /**
     * DELETE /data-stores/:id : delete the "id" dataStore.
     *
     * @param id
     *            the id of the dataStore to delete
     * @return the ResponseEntity with status 200 (OK)
     */
    @DeleteMapping("/data-stores/{id}")
    @Timed
    public ResponseEntity<Void> deleteDataStore(@PathVariable String id) {
        log.debug("REST request to delete DataStore : {}", id);
        dataStoreService.delete(id);
        return ResponseEntity.ok().headers(HeaderUtil.createEntityDeletionAlert(ENTITY_NAME, id)).build();
    }
```
