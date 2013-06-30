biimail
=======

Little email system

Inicio sesion
Fin sesion

Inicio sesion
Fin sesion

Inicio sesion
Fin sesion

Entorno
-------

Se trata de una aplicación Ruby(1.9.3) como base y posteriormente para
añadir funcionalidad web se ha usado Rails(3.2).

En un primer momento se modeló todo en memoria, pero gracias al uso del
patrón Repository el cambio del modelo de persistencia en memoria a uno
en disco fue casi trivial.

Las bases de datos usadas han sido.
MongoDB
Redis

Arquitectura
------------

El enfoque que se ha seguido ha sido el siguiente:
Por un lado se almacenarán los emails que han sido enviados en un hash
con clave id (en caso del repositorio de memoria uno generado, en el
caso de mongodb su propio id) y por otra parte tendremos un hash con
clave igual al email de los usuarios que han recibido un mail y como
valor una lista con los ids de los diferentes mails que han recibido.

Por ejemplo:

  Emails:

  idemail1 -> Email1
  idemail2 -> Email2

  Referencias:

  francisco.fernandez.castano@gmail.com -> [idemail1, idemail2]
  test@gmail.com -> [idemail1]


Por tanto en ningún momento nos encontramos con datos duplicados,
solamente tenemos referencias a esos emails que se encuentran en el
sistema.

Las principales clases del programa son las siguientes

### Client ###

La cual es responsable de gestionar los emails de cada usuario, teniendo
una persistencia gestionada por un repositorio. También se encarga de
enviar los emails así como descargar los emails del servidor el cual
puede ser remoto o local.

### Server ###

Es la encargada de persistir los datos de los emails enviados, asi como
de borrar los emails que no han sido descargados a los 3 meses. También
se encarga de comprobar si un usuario tiene emails pendientes
comprobando en su lista de referencias si su longitud es mayor a 0. 
Devuelte la lista de emails pendientes por descargar dado un cliente en
particular. Así como de proporcionar la descarga de un mail a un
cliente, en esa acción el servidor borra la referencia de ese email
pendiente por descargar en la lista de referencias del receptor que
solicita el email y si todos los usuarios han descargado ya el email lo
borra del repositorio.

### Email ###

Se trata de una clase envoltorio que trata con los diferentes tipos de
datos que nos podemos encontrar, por ejemplo traduce de hash a una
instancia Email, dada una respuesta http también traduce a una instancia
de Email. Por otra parte hace la operación contraria, convierte a hash
para así poder tratar con estos datos de forma cómoda a la hora de hacer
peticiones mediante REST.

### Repository ###

Se trata basicamente de la implementación del patrón repository, en esta
clase los distintos repositorios se registran y las clases que son
clientes del mismo solicitan mediante el método for(tipo) el tipo de
repositorio necesario.

Finalmente los repositorios basicamente adecuan las estructuras de datos
con las que estamos tratando a las necesidades.

En ellas tenemos las operaciones de insertar, eliminar, recorrer,
buscar, etc tipicos de bases de datos.

### RemoteBiimail ###

Haciendo uso de la biblioteca Faraday se ha construido un cliente http
para consumir los recursos expuestos en una API REST por parte del
servidor de correos, lo que hacemos es mapear las llamadas en métodos de
este módulo y construimos las estructuras de datos que debe consumir
nuestro cliente.

### RemoteServer ###

Esta clase toma como delegado a RemoteBiiMail teniendo la misma interfaz
que Server para que el cambio entre un enfoque no distribuido y si
distribuido sea trivial.

Web
----

Se trata de una aplicación Rails muy rudimentaria que nos permite
autenticarnos en el sistema con el email y escribir, descargar o leer
emails. En el controlador Emails tenemos la mayor parte de la lógica de
la aplicación web que se basa en la clase Client descrita anteriormente.

Se ha implementado tanto de forma local como de forma distribuida.
En la parte distribuida tenemos un servidor que ofrece una API REST
sobre los emails que lo único que hace es una capa delante de la clase
Server. El servidor REST está en el otro repositorio.

Para cambiar del enfoque distribuido al no distribuido simplemente
tenemos que cambiar en el fichero config/initializers/biiserver.rb
  
  $server = RemoteServer.new

por:
  
  $server = Server.new

La configuración del servidor remoto se recoge en el fichero:
  config/remote_server.yml

Dependencias
------------
MongoDB
Redis
Ruby

Arrancar la aplicación
----------------------
Instalamos las dependencias
Nos situamos en el directorio de la aplicación y ejecutamos
  bundle install
  rails s

Tests
-----
En la carpeta specs/models hay unos test básicos de la aplicación.

Código ajeno utilizado
----------------------
Rails
Bootstrap
mongo - mongodb ruby driver
bson - "Traductor" de documentos de mongo
redis - redis ruby driver
faraday - cliente http ruby
rspec - Framework de testing

Inspiración para usar el patrón repository de
http://blog.8thlight.com/mike-ebert/2013/03/23/the-repository-pattern.html

