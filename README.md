# Day 01 — Docker Website

## Tools
Linux, Bash, Git, Docker, Nginx, curl.

## What I built
I built a custom Docker image for a static website using Nginx. I created a Dockerfile, built the image, started a container with port mapping, and created a Bash script using curl to automatically verify that the website was responding correctly.

## Evidence to record after running the lab
- Image build result: 
Successfully Build the Docker Image haseeb-lab:v1
- Website check result:
The Container was running Successfuly & the Bash HTTP check confirmed that the website was accessible on the confirmed port
- Check result when the container was stopped:
After stopping the container, the HTTP check failed because the website was no longer reachable. The script returned a non-zero exit code.
- Recovery result:
After starting the container again, the website became accessible and the automated HTTP check passed successfully.

## What I learned
###Image vs Container

A Docker image is a reusable, read-only template containing the application, files, and required software.

A container is a running instance of that image.

###For example:

haseeb-lab:v1 → Docker image
haseeb-website → running container created from that image

One Docker image can be used to create multiple containers.

###Port Mapping

Docker containers have their own ports. Port mapping allows a port on the EC2/Linux host to forward traffic to a port inside the container.

###For example:

8081:80

means:

Host port 8081 → Container port 80

So when I access:

http://127.0.0.1:8081

Docker forwards the request to Nginx running on port 80 inside the container.

Exit Codes

Exit codes tell us whether a Linux command or script completed successfully.

0 = success
Any non-zero value = failure/error

For example, my website check script uses curl. If the website responds successfully, the command returns exit code 0. If the container is stopped and the website cannot be reached, curl returns a non-zero exit code.

This is important in DevOps because Jenkins and other CI/CD tools use exit codes to decide whether a pipeline stage has passed or failed.

Lab Flow

Dockerfile
→ Build Docker Image
→ Run Container
→ Map Host Port to Container Port
→ Test Website with curl
→ Stop Container and verify failure
→ Start Container again
→ Verify recovery

# Day 02 — Jenkins Docker Build and Check

**Date:** 13 September 2026
**DevOps Daily Practice — Day 02**

## Overview

On Day 02, I integrated **Jenkins with my Docker website project** and created a basic CI pipeline.

The main goal was to automatically:

1. Get the project source code.
2. Build a Docker image.
3. Run the application inside a Docker container.
4. Check whether the website is responding correctly.
5. Fail the Jenkins build automatically if the website check fails.

This was my first practical step toward understanding how **Continuous Integration (CI)** works.

---

## CI Workflow

```text
GitHub
   ↓
Jenkins
   ↓
Build Docker Image
   ↓
Run Container
   ↓
Smoke Test
   ↓
Build Pass / Fail
```

Instead of manually building and checking the Docker container every time, Jenkins performs these steps automatically.

---

## Technologies Used

* Linux — Amazon Linux
* Git
* GitHub
* Docker
* Jenkins
* Bash
* Nginx
* curl

---

## Project Structure

```text
day01-docker-website/
│
├── Dockerfile
├── Jenkinsfile
├── index.html
│
└── scripts/
    ├── check.sh
    └── ci-smoke.sh
```

### `Dockerfile`

The Dockerfile creates the Docker image for the Nginx website.

### `index.html`

Contains the webpage displayed by the Nginx container.

### `Jenkinsfile`

Defines the Jenkins CI pipeline and its stages.

### `scripts/check.sh`

Checks whether the website is responding correctly.

### `scripts/ci-smoke.sh`

Starts and verifies the Docker container during the Jenkins pipeline.

---

## Jenkins Pipeline

The Jenkins pipeline performs the main CI operations automatically.

```text
Pipeline Start
      ↓
Checkout Source Code
      ↓
Build Docker Image
      ↓
Run Smoke Test
      ↓
Verify Website
      ↓
Pipeline Success
```

If any important command returns an error, Jenkins marks the build as failed.

---

## Docker Build

Jenkins builds the Docker image using the project's Dockerfile.

Example:

```bash
docker build -t day01-docker-website .
```

Docker reads the Dockerfile and creates an image containing the Nginx web server and website files.

---

## Automated Website Check

After building the image, the pipeline runs a temporary Docker container.

The smoke-test script checks the application using tools such as:

```bash
curl
```

The check confirms that:

* The container starts successfully.
* Nginx responds over HTTP.
* The expected webpage content is available.

If the check fails, Jenkins reports the pipeline as failed.

---

## Why Smoke Testing Is Important

Building a Docker image successfully does not automatically mean that the application inside it works.

For example:

```text
Docker image builds successfully
             ↓
Container starts
             ↓
Website check
       ↙           ↘
    PASS           FAIL
     ↓               ↓
Pipeline Success   Pipeline Failed
```

The smoke test gives an additional level of verification before the image is considered usable.

---

## What I Learned

During this lab, I practiced:

* Creating a Jenkins pipeline with a `Jenkinsfile`.
* Connecting Jenkins with a Git-based project.
* Building Docker images through Jenkins.
* Running Docker commands from Jenkins.
* Using Bash scripts inside a CI pipeline.
* Checking an HTTP service using `curl`.
* Understanding command exit codes.
* Automatically failing a pipeline when a test fails.
* Understanding the basic idea of Continuous Integration.

---

## CI Concept Learned

Before Jenkins, the workflow was mostly manual:

```text
Write Code
   ↓
Build Image Manually
   ↓
Run Container Manually
   ↓
Check Website Manually
```

With Jenkins:

```text
Push/Provide Code
       ↓
     Jenkins
       ↓
Build → Test → Verify
```

This showed me how CI tools automate repetitive build and testing operations.

---

## Successful Result

The Jenkins pipeline successfully:

```text
✓ Retrieved the project
✓ Built the Docker image
✓ Started the test container
✓ Checked the website
✓ Verified the expected response
✓ Completed the Jenkins build successfully
```

This means Jenkins was able to automatically build and verify the Dockerized website.

---

## Important Understanding

This lab is a **CI pipeline**, not yet a complete production deployment pipeline.

Currently:

```text
GitHub → Jenkins → Docker Build → Test
```

The Docker image is built and tested, but it is not yet automatically deployed to a production server.

Future labs will extend this workflow.

---

## Next Step

The next step is to publish the tested Docker image to a container registry such as **Docker Hub**.

The workflow will become:

```text
GitHub
   ↓
Jenkins
   ↓
Build
   ↓
Test
   ↓
Docker Hub
```

After that, the image can be pulled and deployed on another machine or environment.

---

## Daily DevOps Progress

**Day 01:** Linux + Git + Docker + Nginx Website
**Day 02:** Jenkins + Docker Build + Automated Check
**Next:** Docker Registry / Docker Hub

---

## Author

**Haseeb Akbar**

Learning DevOps through hands-on labs focused on:

`Linux` • `Git/GitHub` • `Docker` • `Jenkins` • `AWS` • `CI/CD`
