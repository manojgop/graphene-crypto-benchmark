<!--
Licensed under Creative Commons Attribution 4.0 International License
https://creativecommons.org/licenses/by/4.0/
-->

# OpenSSL Crypto benchmark with Graphene SGX

## Introduction
* [Graphene Library OS](https://graphene.readthedocs.io/en/latest/index.html) supports running unmodified Linux applications on Intel SGX. A Library OS (or "LibOS") provides an Operating System environment in a user space library to execute an application.
* Benchmark openSSL 1.1.1h version with Graphene SGX .
* OpenSSL speed test is executed for aes-gcm-128 encryption and SHA-256.

## Building and Running without Intel SGX

- To build and run crypto benchmark execute the following command from top level repo directory:

  `docker-compose up`

## Building and Running with Graphene SGX

- Before building and running benchmark for Graphene-SGX, we need to install Intel SGX driver and Graphene SGX driver.

  - Clone the Graphene codebase from [here](https://github.com/oscarlab/graphene.git) if not done already. Then, to install Graphene SGX driver please refer https://graphene.readthedocs.io/en/latest/building.html#install-the-graphene-sgx-driver-not-for-production.
  
- To build docker image for Graphene-SGX, we need to use [Graphene Shielded Container](https://github.com/oscarlab/graphene/tree/master/Tools/gsc) (GSC) tool. 

- To build graphene based docker image, we need the non-SGX docker image *cryptotest* built earlier and graphene manifest files for the application.

- Run the following command from Graphene git repository root directory:

  1. Create GSC build configuration file using following commands :

     `cd Tools/gsc`

     `cp config.yaml.template config.yaml`

     *# Adopt config.yaml to the installed Intel SGX driver and desired Graphene repository.*

     *# Use below configuration*.

     ```
     Distro: "ubuntu18.04"
     Graphene:
         Repository: "https://github.com/oscarlab/graphene.git"
         Branch: "master"
     SGXDriver:
         Repository: "https://github.com/01org/linux-sgx-driver.git"
         Branch: "sgx_driver_2.6"
     ```

  2. Copy the Graphene crypto test GSC build script file *build_gsc_crypto_test.sh* from <graphene-crypto-benchmark_repo>/graphene to <graphene_repo>/Tools/gsc using following command :

     `cp <path of build_gsc_crypto_test.sh> Tools/gsc`

  3. Set *CRYPTO_TEST_HOME* to the top level directory of your graphene-crypto-benchmark source repository.

     `export CRYPTO_TEST_HOME=<path of graphene-crypto-benchmark repo top level directory>`

  4. Graphenize Crypto test docker image using following command :

     `./build_gsc_crypto_test.sh`

  Above command if run successfully will generate a Graphene based docker image *gsc-cryptotest*.
  
  5.  Execute the following command from top level repo directory.
  
     `docker-compose -f docker-compose.yaml -f graphene-sgx.yaml up`

## Known issues

- All RDTSC/RDTSCP instructions are emulated (imprecisely) via gettime() syscall in Graphene-SGX.

## Reference
* [Graphene Library OS](
  https://github.com/oscarlab/graphene#graphene-library-os-with-intel-sgx-support)
  Graphene Library OS GitHub.
* [Docker integration via Graphene Shielded Containers](
  https://github.com/oscarlab/graphene/blob/master/Documentation/manpages/gsc.rst)
  Graphene Shielded Containers documentation.
* [OpenSSL Speed Test](
  https://www.openssl.org/docs/man1.1.1/man1/openssl-speed.html)
  OpenSSL Speed test man page.
