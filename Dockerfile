FROM      ubuntu:16.04

# dns
RUN       apt-get update && apt-get install dnsmasq vim dnsutils wget -y
RUN       dnsmasq --version