# Proteus Common Dependencies Bill Of Material Project

A set of compatible versions for all these projects is curated under a BOM ("Bill of Material").

## Using the BOM with Maven
In Maven, you need to import the bom first:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>io.netifi.proteus</groupId>
            <artifactId>proteus-common-dependencies</artifactId>
            <version>Andromeda-BUILD-SNAPSHOT</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```
Notice we use the `<dependencyManagement>` section and the `import` scope.

Next, add your dependencies to the relevant Proteus Common Dependencies projects as usual, except without a `<version>`:

```xml
<dependencies>
    <dependency>
        <groupId>io.rsocket</groupId>
        <artifactId>rsocket-core</artifactId>
    </dependency>
    <dependency>
        <groupId>io.rsocket</groupId>
        <artifactId>rsocket-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

## Using the BOM with Gradle
### Gradle 5.0+
Use the `platform` keyword to import the Maven BOM within the `dependencies` block, then add dependencies to
your project without a version number.

```groovy
dependencies {
     // import BOM
     implementation platform('io.netifi.proteus:proteus-common-dependencies:Andromeda-BUILD-SNAPSHOT')

     // add dependencies without a version number
     implementation 'io.rsocket:rsocket-core'
}
```

### Gradle 4.x and earlier
Gradle versions prior to 5.0 have no core support for Maven BOMs, but you can use Spring's [`gradle-dependency-management` plugin](https://github.com/spring-gradle-plugins/dependency-management-plugin).

First, apply the plugin from Gradle Plugin Portal (check and change the version if a new one has been released):

```groovy
plugins {
    id "io.spring.dependency-management" version "1.0.7.RELEASE"
}
```
Then use it to import the BOM:

```groovy
dependencyManagement {
     imports {
          mavenBom "io.netifi.proteus:proteus-common-dependencies:Andromeda-BUILD-SNAPSHOT"
     }
}
```

Then add a dependency to your project without a version number:

```groovy
dependencies {
     compile 'io.rsocket:rsocket-core'
}
```


## BOM Versioning Scheme
The BOM can be imported in Maven, which will provide a set of default artifact versions to use whenever the corresponding dependency is added to a pom without an explicitly provided version.

As the different artifacts versions are not necessarily aligned, the BOM represents a release train with a codename-based versioning scheme: the usual MAJOR.MINOR numbers are replaced by a constellation name from the [Lists of stars by constellation](https://en.wikipedia.org/wiki/Lists_of_stars_by_constellation), in growing alphabetical order.

The first stable release is simply suffixed with `-RELEASE`, but the equivalent of patch releases are also possible as "Service Releases", appending the suffix `-SR` followed by the number of the service release (eg. `-SR1`, `-SR2`).


### Snapshot Artifacts

While Stable Releases are synchronized with Maven Central, fresh snapshot and milestone artifacts are provided in the _repo.spring.io_ repositories.

To add this repo to your Maven build, add it to the `<repositories>` section like the following:

```xml
<repositories>
	<repository>
	    <id>rsocket-snapshot</id>
	    <name>RSocket Snapshot Repository</name>
	    <url>https://dl.bintray.com/netifi/netifi-oss</url>
	    <snapshots>
	        <enabled>true</enabled>
	    </snapshots>
	</repository>
</repositories>
```

To add it to your Gradle build, use the `repositories` configuration like this:
```groovy
repositories {
	maven { url 'https://dl.bintray.com/netifi/netifi-oss' }
	mavenCentral()
}
```

You should then be able to import a `BUILD-SNAPSHOT` version of the BOM, like `Andromeda-BUILD-SNAPSHOT`.

_Sponsored by [Netifi, Inc](https://www.netifi.com)_
