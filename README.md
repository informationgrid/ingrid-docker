# InGrid Sample Installation

This installation is not for production. It intended use is to get an impression of the functionality.
This README covers only configuration for a local test case. The Editor (and Keycloak) require additional configuration to make this services production ready.

Clone this repository and open a shell in it. The setup works on localhost or on a remote machine. If you're on a remote, you have to change the HOST-variable, see section *Change Host*. This setup may cause problems if you're on a mac, see section *Remarks for Mac Users*.

```sh
# Use the provided sample .env file.
cp .env.sample .env

# This is the default domain-name for testing on your local machine.
# On linux *.localhost domains are per default routed to localhost, on mac you have to add this entry to /etc/hosts
# 127.0.0.1       ingrid.localhost
HOST=ingrid.localhost

# copy initial sample webmapclient data
cp -r portal/WebmapClientData.test/* _data/portal/WebmapClientData

# create empty directory for Postgres Database
mkdir ./_data/postgres-db

# the ingrid containers and elastic container run with UID 1000
sudo chown -R 1000:1000 ./_data

# increase memory for elastic; if you don't do this, elastic won't even boot because it checks for a sane value
# don't run these lines if you're on mac
sysctl vm.max_map_count
sudo sysctl -w vm.max_map_count=262144

# The installation uses docker images from a non-public docker registry. You can also build your own images by following the instructions in the specific ingrid repositories.
sudo docker login -u readonly -p readonly docker-registry.wemove.com > /dev/null # password "readonly"
sudo docker compose up -d
sudo docker compose ps
```

Open the portal at https://ingrid.localhost and accept the self-signed certificate warning. The services need some time to index the sample data, so they may be inaccessible for about a minute or two.

Set confidential passwords as described in section *Set Passwords*.

The default installation includes all optional plugins. To disable them, comment them out in file `docker-compose.yml`.

Modify the default configuration via the components' admin-guis. The urls for them are:

* <http://ingrid.localhost/ige-ng> : http login ige:admin
* <http://ingrid.localhost/keycloak> : http login admin:admin
* <https://ingrid.localhost/codelist-repo> : http login admin:admin
* <https://ingrid.localhost/adminer> : http login admin:admin, postgres-db:postgres:postgres
* <https://ingrid.localhost/ibus-gui/r> : http login admin:admin, ibus login admin:admin
* <https://ingrid.localhost/iplug-admin-sns/> : admin:admin
* <https://ingrid.localhost/iplug-admin-opensearch/> : admin:admin
* <https://ingrid.localhost/iplug-admin-wfs-dsc/> : admin:admin
* <https://ingrid.localhost/iplug-admin-wfs-dsc-zdm/> : admin:admin
* <https://ingrid.localhost/iplug-admin-dsc/> : admin:admin
* <https://ingrid.localhost/iplug-admin-se/> : admin:admin
* <https://ingrid.localhost/interface-csw-admin/> : admin:admin
* <https://ingrid.localhost/iplug-admin-csw-dsc/> : admin:admin

You can find detailed explanations about the configuration on <https://www.ingrid-oss.eu/latest/index.html>.


## Change Host

The default host is set to `ingrid.localhost`, which resolves to localhost on linux machines. If you are on a server, you need to configure the server's domain name as follows:

```sh
HOST=your.domain.name
sed -i "s/ingrid.localhost/$HOST/g" \
  .env \
  apache/httpd.conf \
  apache/vhost.conf \
  interface-search/descriptor.xml \
  interface-search/interface-search.properties \
  interface-csw/conf/config.override.properties \
  iplug-csw/conf/config.override.properties \
  iplug-dsc/conf/config.override.properties \
  iplug-dsc/conf/mapping/igc_to_idf_obj_dq.js \
  iplug-excel/conf/config.override.properties \
  iplug-excel/conf/config.override.properties \
  iplug-ige/config.override.properties \
  iplug-opensearch/conf/config.override.properties \
  iplug-opensearch/conf/config.override.properties \
  iplug-se/conf/config.override.properties \
  iplug-se/conf/config.override.properties \
  iplug-sns/conf/config.override.properties \
  iplug-wfs/conf/config.override.properties \
  iplug-wfs/conf/config.override.properties \
  iplug-wfs-zdm/conf/config.override.properties \
  iplug-wfs-zdm/conf/config.override.properties \
  iplug-xml/conf/config.override.properties \
  iplug-xml/conf/config.override.properties \
  iplug-xml/mapping/pom.xml_20111128102421/pom.xml_20111128102421 \
  portal/ingrid-portal-apps.override.properties \
  portal/mdek.override.properties \
  server-opensearch/plugdescription.xml \
  server-opensearch/plugdescription.xml \
  server-opensearch/ingrid-opensearch.properties
```

If you're on mac, use:

```sh
HOST=your.domain.name
sed -i "" "s/ingrid.localhost/$HOST/g" \
  .env \
  apache/httpd.conf \
  apache/vhost.conf \
  interface-search/descriptor.xml \
  interface-search/interface-search.properties \
  interface-csw/conf/config.override.properties \
  iplug-csw/conf/config.override.properties \
  iplug-dsc/conf/config.override.properties \
  iplug-dsc/conf/mapping/igc_to_idf_obj_dq.js \
  iplug-excel/conf/config.override.properties \
  iplug-excel/conf/config.override.properties \
  iplug-ige/config.override.properties \
  iplug-opensearch/conf/config.override.properties \
  iplug-opensearch/conf/config.override.properties \
  iplug-se/conf/config.override.properties \
  iplug-se/conf/config.override.properties \
  iplug-sns/conf/config.override.properties \
  iplug-wfs/conf/config.override.properties \
  iplug-wfs/conf/config.override.properties \
  iplug-wfs-zdm/conf/config.override.properties \
  iplug-wfs-zdm/conf/config.override.properties \
  iplug-xml/conf/config.override.properties \
  iplug-xml/conf/config.override.properties \
  iplug-xml/mapping/pom.xml_20111128102421/pom.xml_20111128102421 \
  portal/ingrid-portal-apps.override.properties \
  portal/mdek.override.properties \
  server-opensearch/plugdescription.xml \
  server-opensearch/plugdescription.xml \
  server-opensearch/ingrid-opensearch.properties
```

If you updated the host-setting afterwards, update your setup with:

```sh
# update containers with changed docker compose arguments (.env has changed)
sudo docker compose up -d
# update containers with changed settings files
sudo docker compose restart
```

## Remarks

In this configuration the Editor and the Keycloak require to be called with http:// /and not https://)

Some pages of the portal are secured via http-auth as defined in `./apache/passwdfile.ingrid` and in `.apache/vhost.conf`. The default logins are admin/admin and ingrid/ingrid. The logins for all iplugs are also admin/admin as default.

The containers can be restarted at any time. Possible running indexing processes are automatically cleaned up. If you change the configuration of a service via the files in this repository, you have to restart the container to apply them.

You can comment out services from the `docker-compose.yml` to disable them.

Almost each service has an own administration web gui. You can find the url needed to access them in the file `apache/vhost.conf`.

## Remarks for Mac Users

Our last test-run on mac with docker-for-mac installed had issues with mysql and sslproxy. The mysql-container was continuously restarting while the sslproxy-container exited with error 128. If you're on a mac and interested in getting this to work on your machine, drop us a note. Currently we don't have active ingrid users on mac machines so we didn't further investigate.

## Set Passwords

### Database

Change property `POSTGRES_DB_PASSWORD` in file `.env`.

Change property `iplug.database.password` in files `iplug-dsc/conf/config.override.properties` and environment variable of `ige-ng` and `keycloak`.

### Codelist

Change property `CODELIST_PASSWORD`  in file `.env`.

Change line `admin: yourpassword,admin` in file `codelist-repository/realm.properties`.

Change property `codelist.password` in file `portal/mdek.override.properties`.

### Admin GUI

Each ingrid-component has its own admin-gui. You can login with user 'admin'. Choose a password for the admin-gui. You can keep it for example in the file `.env`. Create its bcrypt hash with the command:

```sh
htpasswd -nbBC 10 admin yourpassword
```

Take the part behind the colon. Rename `$2y` to `$2a` (compatibility with pre-v2.2.0.M2 spring version).

Change property `ADMIN_GUI_PASSWORD_HASH` in file `.env`.

Change property `ingrid.admin.password` in file `interface-csw\conf\config.override.properties`. Change property `plugdescription.IPLUG_ADMIN_PASSWORD` in files

* `iplug-csw\conf\config.override.properties`
* `iplug-dsc\conf\config.override.properties`
* `iplug-excel\conf\config.override.properties`
* `iplug-ige\config.override.properties`
* `iplug-opensearch\conf\config.override.properties`
* `iplug-se\conf\config.override.properties`
* `iplug-sns\conf\config.override.properties`
* `iplug-wfs\conf\config.override.properties`
* `iplug-wfs-zdm\conf\config.override.properties`
* `iplug-xml\conf\config.override.properties`

### Http Auth

The admin-guis of phpmyadmin, ibus and ige are secured with http-auth. For the ibus and ige admin-gui this is redundant security. Choose a username and password. You can keep them for example in the file `.env`. Create the apr-hash of the password with the command:

```sh
openssl passwd -apr1 yourpassword
```

and replace the content of file `apache/passwdfile.ingrid` with the line `yourusername:yourpasswordhash`.

### Finally

After changing your passwords, run:

```sh
# update containers with changed docker compose arguments (.env has changed)
sudo docker compose up -d
# update containers with changed settings files
sudo docker compose restart
```
