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
