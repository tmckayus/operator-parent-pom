# operator-parent-pom

[![Build status](https://travis-ci.org/jvm-operators/operator-parent-pom.svg?branch=master)](https://travis-ci.org/jvm-operators/operator-parent-pom)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

Common Maven parent pom file with dependency management, plugin management and properties.

### Usage
In your maven pom.xml use this:

```xml
    <parent>
        <groupId>io.radanalytics</groupId>
        <artifactId>operator-parent-pom</artifactId>
        <version>x.y.z</version>
    </parent>

```
where `x.y.z` is the version of this artifact.
