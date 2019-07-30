# Pentaho BI Server
This project contains a Docker Image for deploying Pentaho BI Server with Tomcat and also contains the AthenaJDBC driver to enable connections to Amazon Athena


###How to run this image
```sh
$ docker run --name my-bi-server -p 8080:8080 -d pentaho-server:tag
```

!!!!!!!!!!!!!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

For this image to work, put your modified config files in the "pentaho-db-config" directory(repository.xml, quartz.properties & context.xml, read on for instructions on how to edit these files)

When using a custom db environment it's necessary to create the db users, tables and schemas that Pentaho needs. You can find the PostgreSQL scripts in the postgresql-db-scripts directory. For other database engines you can find the corresponding scripts within the Pentaho Community Edition distribution, under /pentaho-server/data

For postgresql just run create_quartz_postgresql.sql,create_repository_postgresql.sql and create_jcr_postgresql.sql on your Postgresql DB instance

!!!!!!!!!!!!!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


By default Pentaho Server uses the file-system repository but you can change it to one of the supported databases.

Here you can find the specific setup steps for each type of database:

 - [PostgreSQL][PSQL]
 - [MySQL][MSQL]
 - [Oracle][ORCL]
 - [MS SQL Server][MSSQL]

Make sure that your db repository is up and running and has the necessary schemas, then you basically need to edit three files to specify your custom connections

You can find a copy of the configuration files on this [repo][PDBCONF], download them and edit them with your own connections

##For a PostgreSQL repository:

###Step 1: Set up Quartz on PostgreSQL
Event information, such as scheduled reports, is stored in the Quartz JobStore. During the installation process, you must indicate where the JobStore is located by modifying the quartz.properties file.

Open quartz.properties file in any text editor.
Locate the #_replace_jobstore_properties section and set the org.quartz.jobStore.driverDelegateClass as shown:

```sh
- 1 | org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.PostgreSQLDelegate
```

Locate the # Configure Datasources section and set the org.quartz.dataSource.myDS.jndiURL equal to Quartz, as shown:

```sh
- 1 | org.quartz.dataSource.myDS.jndiURL = Quartz
```
Save the file and close the text editor.

### Step 2: Modify Jackrabbit repository information for PostgreSQL
Edit the following code to change the default Jackrabbit repository to PostgreSQL.

Open the repository.xml file with any text editor.

As shown in the table below, locate and verify or change the code so that the PostgreSQL lines are not commented out, but the MySQL, Oracle, and MS SQL Server lines are commented out.

Caution : If you have a different port or different password, make sure that you change the password and port number in these examples to match the ones in your configuration.

<table><thead><tr><td width="50.0%">Item</td><td width="50.0%">Code Section</td></tr></thead><tbody><tr><td width="50.0%">Repository</td><td width="50.0%">
										<div id="highlighter_302944" class="syntaxhighlighter  "><div class="bar                      "><div class="toolbar"></div></div><div class="lines"><div class="line alt1"><table><tbody><tr><td class="number"><code>1</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">FileSystem</code> <code class="color1">class</code><code class="plain">=</code><code class="string">"org.apache.jackrabbit.core.fs.db.DbFileSystem"</code><code class="plain">&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>2</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"driver"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>3</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"url"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/jackrabbit">postgresql://localhost:5432/jackrabbit</a>"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>4</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">...</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>5</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">&lt;/</code><code class="keyword">FileSystem</code><code class="plain">&gt;</code></td></tr></tbody></table></div></div></div>
									</td></tr><tr><td width="50.0%">DataStore</td><td width="50.0%">
										<div id="highlighter_656506" class="syntaxhighlighter  "><div class="bar                                                            "><div class="toolbar"></div></div><div class="lines"><div class="line alt1"><table><tbody><tr><td class="number"><code>1</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">DataStore</code> <code class="color1">class</code><code class="plain">=</code><code class="string">"org.apache.jackrabbit.core.data.db.DbDataStore"</code><code class="plain">&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>2</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"url"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/jackrabbit">postgresql://localhost:5432/jackrabbit</a>"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>3</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">...</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>4</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">&lt;/</code><code class="keyword">DataStore</code><code class="plain">&gt;</code></td></tr></tbody></table></div></div></div>
									</td></tr><tr><td width="50.0%">Workspaces</td><td width="50.0%">
										<div id="highlighter_753597" class="syntaxhighlighter  "><div class="bar        "><div class="toolbar"></div></div><div class="lines"><div class="line alt1"><table><tbody><tr><td class="number"><code>1</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">FileSystem</code> <code class="color1">class</code><code class="plain">=</code><code class="string">"org.apache.jackrabbit.core.fs.db.DbFileSystem"</code><code class="plain">&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>2</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"driver"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>3</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"url"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/jackrabbit">postgresql://localhost:5432/jackrabbit</a>"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>4</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">...</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>5</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;/</code><code class="keyword">FileSystem</code><code class="plain">&gt;</code></td></tr></tbody></table></div></div></div>
									</td></tr><tr><td width="50.0%">PersistenceManager (1st part)</td><td width="50.0%">
										<div id="highlighter_60681" class="syntaxhighlighter  "><div class="bar     "><div class="toolbar"></div></div><div class="lines"><div class="line alt1"><table><tbody><tr><td class="number"><code>1</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">PersistenceManager</code> <code class="color1">class</code><code class="plain">=</code><code class="string">"org.apache.jackrabbit.core.persistence.bundle.PostgreSQLPersistenceManager"</code><code class="plain">&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>2</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"url"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/jackrabbit">postgresql://localhost:5432/jackrabbit</a>"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>3</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">...</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>4</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"schemaObjectPrefix"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"${wsp.name}_pm_ws_"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>5</code></td><td class="content"><code class="plain">&lt;/</code><code class="keyword">PersistenceManager</code><code class="plain">&gt;</code></td></tr></tbody></table></div></div></div>
									</td></tr><tr><td width="50.0%">Versioning</td><td width="50.0%">
										<div id="highlighter_691636" class="syntaxhighlighter  "><div class="bar       "><div class="toolbar"></div></div><div class="lines"><div class="line alt1"><table><tbody><tr><td class="number"><code>1</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">FileSystem</code> <code class="color1">class</code><code class="plain">=</code><code class="string">"org.apache.jackrabbit.core.fs.db.DbFileSystem"</code><code class="plain">&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>2</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"driver"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>3</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"url"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/jackrabbit">postgresql://localhost:5432/jackrabbit</a>"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>4</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">...</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>5</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;/</code><code class="keyword">FileSystem</code><code class="plain">&gt;</code></td></tr></tbody></table></div></div></div>
									</td></tr><tr><td width="50.0%">PersistenceManager (2nd part)</td><td width="50.0%">
										<div id="highlighter_892105" class="syntaxhighlighter  "><div class="bar      "><div class="toolbar"></div></div><div class="lines"><div class="line alt1"><table><tbody><tr><td class="number"><code>1</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">PersistenceManager</code> <code class="color1">class</code><code class="plain">=</code><code class="string">"org.apache.jackrabbit.core.persistence.bundle.PostgreSQLPersistenceManager"</code><code class="plain">&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>2</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"url"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/jackrabbit">postgresql://localhost:5432/jackrabbit</a>"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>3</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">...</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>4</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"schemaObjectPrefix"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"pm_ver_"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>5</code></td><td class="content"><code class="plain">&lt;/</code><code class="keyword">PersistenceManager</code><code class="plain">&gt;</code></td></tr></tbody></table></div></div></div>
									</td></tr><tr><td width="50.0%">DatabaseJournal</td><td width="50.0%">
										<div id="highlighter_315735" class="syntaxhighlighter  "><div class="bar               "><div class="toolbar"></div></div><div class="lines"><div class="line alt1"><table><tbody><tr><td class="number"><code>01</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">Journal</code> <code class="color1">class</code><code class="plain">=</code><code class="string">"org.apache.jackrabbit.core.journal.DatabaseJournal"</code><code class="plain">&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>02</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"revision"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"${rep.home}/revision.log"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>03</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"url"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/jackrabbit">postgresql://localhost:5432/jackrabbit</a>"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>04</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"driver"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>05</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"user"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"jcr_user"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>06</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"password"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"password"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>07</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"schema"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"postgresql"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>08</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"schemaObjectPrefix"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"cl_j_"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>09</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"janitorEnabled"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"true"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>10</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"janitorSleep"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"86400"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>11</code></td><td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">&lt;</code><code class="keyword">param</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"janitorFirstRunHourOfDay"</code> <code class="color1">value</code><code class="plain">=</code><code class="string">"3"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>12</code></td><td class="content"><code class="plain">&lt;/</code><code class="keyword">Journal</code><code class="plain">&gt;</code></td></tr></tbody></table></div></div></div>
									</td></tr></tbody></table>
									
##Step 3: Modify JDBC connection information in the Tomcat context.xml File
Database connection and network information, such as the username, password, driver class information, IP address or domain name, and port numbers for your Pentaho Repository database are stored in the context.xml file. 

Modify this file to reflect the database connection and network information to reflect your operating environment.

If you have chosen to use an Pentaho Repository database other than PostgreSQL, you also need to modify the values for the validationQuery parameters in this file.

Caution : If you have a different port, password, user, driver class information, or IP address, make sure that you change the password and port number in these examples to match the ones in your configuration environment.
Consult your database documentation to determine the JDBC class name and connection string for yourPentaho Repository database.

- Open the context.xml file with any text editor.

- Add the following code to the file if it does not already exist.
									
<div><div><div></div></div><div><div><table><tbody><tr><td><code>1</code></td><td><code>&lt;</code><code>Resource</code> <code>name</code><code>=</code><code>"jdbc/Hibernate"</code> <code class="color1">auth</code><code class="plain">=</code><code class="string">"Container"</code> <code class="color1">type</code><code class="plain">=</code><code class="string">"javax.sql.DataSource"</code> <code class="color1">factory</code><code class="plain">=</code><code class="string">"org.apache.tomcat.jdbc.pool.DataSourceFactory"</code> <code class="color1">initialSize</code><code class="plain">=</code><code class="string">"0"</code> <code class="color1">maxActive</code><code class="plain">=</code><code class="string">"20"</code> <code class="color1">maxIdle</code><code class="plain">=</code><code class="string">"10"</code> <code class="color1">maxWait</code><code class="plain">=</code><code class="string">"10000"</code> <code class="color1">username</code><code class="plain">=</code><code class="string">"hibuser"</code> <code class="color1">password</code><code class="plain">=</code><code class="string">"password"</code> <code class="color1">driverClassName</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code> <code class="color1">url</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/hibernate">postgresql://localhost:5432/hibernate</a>"</code> <code class="color1">validationQuery</code><code class="plain">=</code><code class="string">"select 1"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>2</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">Resource</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"jdbc/Audit"</code> <code class="color1">auth</code><code class="plain">=</code><code class="string">"Container"</code> <code class="color1">type</code><code class="plain">=</code><code class="string">"javax.sql.DataSource"</code> <code class="color1">factory</code><code class="plain">=</code><code class="string">"org.apache.tomcat.jdbc.pool.DataSourceFactory"</code> <code class="color1">initialSize</code><code class="plain">=</code><code class="string">"0"</code> <code class="color1">maxActive</code><code class="plain">=</code><code class="string">"20"</code> <code class="color1">maxIdle</code><code class="plain">=</code><code class="string">"10"</code> <code class="color1">maxWait</code><code class="plain">=</code><code class="string">"10000"</code> <code class="color1">username</code><code class="plain">=</code><code class="string">"hibuser"</code> <code class="color1">password</code><code class="plain">=</code><code class="string">"password"</code> <code class="color1">driverClassName</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code> <code class="color1">url</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/hibernate">postgresql://localhost:5432/hibernate</a>"</code> <code class="color1">validationQuery</code><code class="plain">=</code><code class="string">"select 1"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>3</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">Resource</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"jdbc/Quartz"</code> <code class="color1">auth</code><code class="plain">=</code><code class="string">"Container"</code> <code class="color1">type</code><code class="plain">=</code><code class="string">"javax.sql.DataSource"</code> <code class="color1">factory</code><code class="plain">=</code><code class="string">"org.apache.tomcat.jdbc.pool.DataSourceFactory"</code> <code class="color1">initialSize</code><code class="plain">=</code><code class="string">"0"</code> <code class="color1">maxActive</code><code class="plain">=</code><code class="string">"20"</code> <code class="color1">maxIdle</code><code class="plain">=</code><code class="string">"10"</code> <code class="color1">maxWait</code><code class="plain">=</code><code class="string">"10000"</code> <code class="color1">username</code><code class="plain">=</code><code class="string">"pentaho_user"</code> <code class="color1">password</code><code class="plain">=</code><code class="string">"password"</code> <code class="color1">driverClassName</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code> <code class="color1">url</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/quartz">postgresql://localhost:5432/quartz</a>"</code> <code class="color1">validationQuery</code><code class="plain">=</code><code class="string">"select 1"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>4</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">Resource</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"jdbc/pentaho_operations_mart"</code> <code class="color1">auth</code><code class="plain">=</code><code class="string">"Container"</code> <code class="color1">type</code><code class="plain">=</code><code class="string">"javax.sql.DataSource"</code> <code class="color1">factory</code><code class="plain">=</code><code class="string">"org.apache.tomcat.jdbc.pool.DataSourceFactory"</code> <code class="color1">initialSize</code><code class="plain">=</code><code class="string">"0"</code> <code class="color1">maxActive</code><code class="plain">=</code><code class="string">"20"</code> <code class="color1">maxIdle</code><code class="plain">=</code><code class="string">"10"</code> <code class="color1">maxWait</code><code class="plain">=</code><code class="string">"10000"</code> <code class="color1">username</code><code class="plain">=</code><code class="string">"hibuser"</code> <code class="color1">password</code><code class="plain">=</code><code class="string">"password"</code> <code class="color1">driverClassName</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code> <code class="color1">url</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/pentaho_operations_mart">postgresql://localhost:5432/pentaho_operations_mart</a>"</code> <code class="color1">validationQuery</code><code class="plain">=</code><code class="string">"select 1"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt1"><table><tbody><tr><td class="number"><code>5</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">Resource</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"jdbc/PDI_Operations_Mart"</code> <code class="color1">auth</code><code class="plain">=</code><code class="string">"Container"</code> <code class="color1">type</code><code class="plain">=</code><code class="string">"javax.sql.DataSource"</code> <code class="color1">factory</code><code class="plain">=</code><code class="string">"org.apache.tomcat.jdbc.pool.DataSourceFactory"</code> <code class="color1">initialSize</code><code class="plain">=</code><code class="string">"0"</code> <code class="color1">maxActive</code><code class="plain">=</code><code class="string">"20"</code> <code class="color1">maxIdle</code><code class="plain">=</code><code class="string">"10"</code> <code class="color1">maxWait</code><code class="plain">=</code><code class="string">"10000"</code> <code class="color1">username</code><code class="plain">=</code><code class="string">"hibuser"</code> <code class="color1">password</code><code class="plain">=</code><code class="string">"password"</code> <code class="color1">driverClassName</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code> <code class="color1">url</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/hibernate">postgresql://localhost:5432/hibernate</a>"</code> <code class="color1">validationQuery</code><code class="plain">=</code><code class="string">"select 1"</code><code class="plain">/&gt;</code></td></tr></tbody></table></div><div class="line alt2"><table><tbody><tr><td class="number"><code>6</code></td><td class="content"><code class="plain">&lt;</code><code class="keyword">Resource</code> <code class="color1">name</code><code class="plain">=</code><code class="string">"jdbc/live_logging_info"</code> <code class="color1">auth</code><code class="plain">=</code><code class="string">"Container"</code> <code class="color1">type</code><code class="plain">=</code><code class="string">"javax.sql.DataSource"</code> <code class="color1">factory</code><code class="plain">=</code><code class="string">"org.apache.tomcat.jdbc.pool.DataSourceFactory"</code> <code class="color1">initialSize</code><code class="plain">=</code><code class="string">"0"</code> <code class="color1">maxActive</code><code class="plain">=</code><code class="string">"20"</code> <code class="color1">maxIdle</code><code class="plain">=</code><code class="string">"10"</code> <code class="color1">maxWait</code><code class="plain">=</code><code class="string">"10000"</code> <code class="color1">username</code><code class="plain">=</code><code class="string">"hibuser"</code> <code class="color1">password</code><code class="plain">=</code><code class="string">"password"</code> <code class="color1">driverClassName</code><code class="plain">=</code><code class="string">"org.postgresql.Driver"</code> <code class="color1">url</code><code class="plain">=</code><code class="string">"jdbc:<a href="postgresql://localhost:5432/hibernate?searchpath=pentaho_dilogs">postgresql://localhost:5432/hibernate?searchpath=pentaho_dilogs</a>"</code> <code>validationQuery</code><code>=</code><code>"select 1"</code><code>/&gt;</code></td></tr></tbody></table></div></div></div>

- Modify the username, password, driver class information, IP address (or domain name), and port numbers so they reflect the correct values for your environment.

- Make sure that the validationQuery variable for your database is set to this: validationQuery="select 1"

- Save the context.xml file

For this image to work, put your modified config files in the "pentaho-db-config" directory(repository.xml, quartz.properties & context.xml, read on for instructions on how to edit these files)

 [PDBCONF]: <https://github.com/doc-com/PentahoServer/tree/master/pentaho-db-config>
 [PSQL]: <https://help.pentaho.com/Documentation/8.3/Setup/Use_PostgreSQL_as_your_repository_database_(Manual_installation)>
 [MSQL]: <https://help.pentaho.com/Documentation/8.3/Setup/Use_MySQL_as_your_repository_database_(Manual_installation)>
 [ORCL]: <https://help.pentaho.com/Documentation/8.3/Setup/Use_Oracle_as_your_repository_database_(Manual_installation)>
 [MSSQL]: <https://help.pentaho.com/Documentation/8.3/Setup/Use_MS_SQL_Server_as_your_repository_database_(Manual_installation)#GUID-166D2A53-436C-4A04-A78A-BEC16B1900F7>