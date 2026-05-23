# Project Report: Sonatype Nexus Repository Manager Setup

## 1. Introduction & Objectives
This report details the implementation of a local proxy repository system using **Sonatype Nexus Repository Manager 3**. 

The primary objective of this project is to optimize the dependency management process for modern application development (specifically focusing on PHP/Laravel, Node.js, and Java). By caching external packages locally, this setup drastically reduces bandwidth consumption, accelerates build and installation speeds, and ensures high availability of dependencies even if the external registries experience downtime.

## 2. Architecture & Containerized Deployment
The Nexus Repository Manager is deployed using Docker, ensuring that the environment is portable, reproducible, and isolated.

* **Docker Orchestration:** A `docker-compose.yml` file handles the deployment using the official `sonatype/nexus3:3.91.1` image.
* **Persistent Storage:** A Docker volume (`nexus-data`) is mounted to `/nexus-data` inside the container. This is a critical step that ensures all downloaded packages, server configurations, and metadata are safely preserved across container restarts and updates.
* **Port Mapping:** The Nexus web interface and REST APIs are exposed to the host machine on port `8081`.

## 3. Proxy Repository Configuration
To support a diverse tech stack, three distinct proxy repositories were created. The configurations were defined using JSON payloads (`npm-repo.json`, `composer-repo.json`, `maven-repo.json`) and injected into Nexus.

1. **Composer Proxy (`composer-proxy`)**: Proxies the primary PHP package registry (`https://packagist.org`).
2. **NPM Proxy (`npm-proxy`)**: Proxies the official Node.js package registry (`https://registry.npmjs.org`).
3. **Maven Proxy (`maven-thongking`)**: Proxies the Maven Central repository (`https://repo1.maven.org/maven2/`) for Java dependencies.

**How it works:** These proxies act as intelligent intermediaries. When a developer (or CI server) requests a package, Nexus first checks its local cache. If the package is missing, Nexus fetches it from the remote registry, serves it to the requester, and simultaneously caches it for all future requests.

## 4. Application Integration (Laravel Case Study)
To validate the setup, a Laravel project (`i42026-website`) was configured to pull its dependencies exclusively through the new Nexus proxy rather than the public internet.

* **Composer Configuration:** The `composer.json` file was modified to override the default Packagist repository. The `repositories` object was updated to force Composer to look at the custom Nexus endpoint.
* **NPM Configuration:** To route JavaScript dependencies, an `.npmrc` file is used at the project root to override the default registry endpoint to point towards the Nexus NPM proxy.

## 5. External Access & Collaboration via Ngrok
A key requirement in modern DevOps is enabling collaboration. To allow external partners to utilize this locally hosted Nexus cache, a secure tunnel was established using **Ngrok**.

* **Tunneling:** Ngrok was configured to forward external HTTPS traffic to the local `localhost:8081` port. 
* **Partner Testing:** The generated Ngrok URL (`https://retrain-crept-blanching.ngrok-free.dev`) was embedded into the Laravel project's `composer.json`. This allowed a remote partner to run `composer install` and successfully pull all dependencies through the local Nexus cache over the internet, proving the system's viability for a distributed team.

## 6. Conclusion
This implementation successfully demonstrates a fundamental DevOps practice. By introducing a Nexus proxy repository into the development lifecycle, the workflow benefits from faster, more reliable, and reproducible builds. It also establishes a centralized hub for managing and auditing all open-source dependencies entering the project ecosystem.
