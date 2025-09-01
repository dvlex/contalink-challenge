# Contalink Code Challenge


## The Challenge: Test para candidatos RoR Engineer

1. Desarrolla una aplicación web de consulta de facturas.
    1. Requerimientos:
        1. Frontend que solicite al usuario una fecha inicial y una fecha final. Envíe al API la petición y muestre los resultados de la consulta al usuario.
        2. API que reciba la petición y regrese la información correspondiente.
        3. Proceso en background que envíe un email con el top 10 de dias donde más se ha vendido todas las mañanas.
        4. Agregar caché para las consultas recientes.
    2. Entregables.
        1. Repositorio con el frontend e instrucciones para lanzarlo (GitHub)
        2. Repositorio con el backend e instrucciones para lanzarlo (GitHub)
    3. Restricciones
        1. El frontend deberá estar desarrollado en React
        2. El API deberá estar desarrollado en Ruby. El API deberá recibir y entregar información en formato JSON.
        3. No documentes tu código.
    4.  Consideraciones.
        1. Esperamos que el front end se vea razonablemente bien, sin embargo, nos interesa más la velocidad en la que se puede entregar el producto.
        2. Si estaremos juzgando la claridad del código, organización y facilidad para interpretarse.
        3. Agrega los tests que creas son necesarios.
        4. Si algo no está claro de los requerimientos aquí planteados, siempre es muy importante aclarar, por lo tanto no se detengan en buscarme para resolver cualquier duda (csalinas@contalink.com)
    5. Base de datos de PostgreSQL para obtener información.
        1. Host: ******
        2. Username: ******
        3. Database: ******
        4. Password: ******
        5. Table: invoices

## Local Running

### 1. Requirements
- Visual Studio Code (VS Code)
- Dev Containers extension for VS Code
- Docker (preferably configured with WSL)
- git configured in your local
- Ensure the following ports are free and available:
    - 3000 (for the web application)
    - 5432 (for PostgreSQL)
    - 6379 (for Redis)

### 2. Clone the repo
You need to clone this repo to your local, to do that in cmd/linux-cli:
`git clone https://github.com/dvlex/contalink-challenge.git`
then
`cd contalink-challenge`
next
`code .`

### 3. Inside VScode
Once you're inside VScode with the contalink-challenge opened, you should open the devcontainer, to work without modify/bug your environment, to do that, press `crtl+shift+p` in windows/linux or `command+shift+p` in macos, that will cast a window and there you need type `Dev Containers: build and open container`, this will start/setup the devcontainer, the first time takes like 3-7min, depending of your internet provider conection; the next time, takes less than 1min, so, don't worry.

### 4. Inside the dev container
#### The env file and bundling
When the devcontainer finish the setup, you can open a terminal, and there, you will have a brand new terminal, with Oh-My-Zsh configured, now you need to generate the `.env` file with the next credentials:
````
ENV_USERNAME=******
ENV_PASSWORD=******
ENV_HOST=******
RAILS_MASTER_KEY=******
````
***WARNING: this credentials shouldn't be here neither saved in the repo, those should be secrets of the platform or GH, I'll send you in the mail, those credentials, and save them in the .env file.

Then run `bundle install`, to set all the gems, including the one that reads the .env file

#### The db setup
Since it's recommendable work with a dev local db, in this project is setted as a docker-compose service, which is initialized automatically by the devcontainer; working with remote DB, even if those are dev/stagging, you expose the IP/port to everyone, and you could have an expensive invoice of your cloud provider, or DoS attack to your bare-metal server. To work locally, follow the next steps(all of them inside the devcontainer):
- In a vscode terminal: `rails db:prepare`, this will create the dev db, make the migrations, and will seed 100,000 mock records emulating the prod/stagging env.
- Now you have the local environment setted, congratulations, you can run the project with `bin/dev`

*Info:* However, if you are ok with the risks of accesing a remote DB engine, you can set in .env the corresponding credentials, but, if you choose this, DON'T use `rails db:prepare`, since this can overwrite data in the remote DB, and you could make a lot of high-caffeine mad developers blame you.

#### Project start
Since we implemented Sidekiq, we can't use just `rails s` but `bin/dev`, becase `bin/dev` initializes both rails sever and Sidekiq server

### 5. Sidekiq
Sidekiq is a powerful background job processor for Ruby applications, designed to handle asynchronous tasks efficiently using Redis. It allows you to offload time-consuming operations—like sending emails, processing data, or generating reports—so your app stays fast and responsive. In this project, the TopTenDaysSellsJob is scheduled to run daily and can be managed directly from the Sidekiq web interface. To view or manually trigger this job, navigate to `/sidekiq/recurring-jobs`, where it appears in the list of scheduled tasks. From there, you can click "Enqueue Now" to execute it immediately, making it easy to test or force a run outside its regular schedule.

### 6. Curl/Postman
It's recommendable to use the Postman extension in Vscode, which allows you to avoid exposing the devcontainer to the LAN/WLAN, but also, you can use Postman App or curl with the next snippet:
`curl --location 'http://localhost:3000/invoices?start_date=%222022-05-13%22&end_date=%222023-05-13%22'`(you can import this to postman)

## Commands related to redis cache
`redis-cli -h redis -p 6379`: You enter to redis server, to check cache keys and cache content

### Redis server commands
`keys dev-cache:*`: you check all the keys inside dev-cache workspace
`get "dev-cache:key"`: you get the value associated with that key
`exit`: you disconnect from the redis server

### rails console commands
`Rails.cache.delete_matched("invoices*")`: you delete all the redis cache content which the keys start with invoices, but only the related to the workspace.
`Rails.cache.read("test_key")`: you get the value associated with that key
`Rails.cache.write("key":"value")`: you create the key value in redis

## ToDo's
- Configure CI/CD pipeline: Since the Dockerfile for deployment, is in the root, there're not yet some GH actions, to the management of CI/CD, please let me know if you need that, and I'll do it.
- it's recommeded to have timestamps in each table, calling about Invoice

## 🧾 Final Thoughts
I'm Alex Castillo, and I want to extend my sincere thanks to Contalink for the opportunity to explore this Rails position through this technical challenge. For the purposes of this repo, I opted to use Redis as the cache store to simplify observability and isolate behavior during testing. However, it's worth noting that the Rails core team recommends using in-disk caching, especially with the rise of fast and affordable NVMe storage, which offers excellent performance for most production workloads. This project was a great chance to revisit conventions, experiment with infrastructure choices, and reflect on best practices.

To know about Rails cache conventions, please visit this URL [Rails Cache Video](https://www.youtube.com/watch?v=mA6somzKYEg)
