#!bash
apt install -y curl unzip xz-utils build-essential cmake libboost-system-dev libboost-program-options-dev libssl-dev git curl
curl -LO https://www.openssl.org/source/openssl-1.1.1e.tar.gz
tar xf openssl-1.1.1e.tar.gz
cd openssl-1.1.1e
./config --openssldir=/etc/ssl enable-ec_nistp_64_gcc_128 no-ssl2 no-ssl3 no-comp no-idea no-dtls no-dtls1 no-shared no-psk no-srp no-ec2m no-weak-ssl-ciphers
make install_sw
cd ..
rm -rf openssl-1.1.1e.tar.gz openssl-1.1.1e

curl -LO https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0.tar.gz
tar xf cmake-3.17.0.tar.gz
cd cmake-3.17.0
./bootstrap --
make -j$(nproc) install
cd ..
rm -rf cmake-3.17.0.tar.gz cmake-3.17.0

curl -LO https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
tar xf boost_1_72_0.tar.gz
cd boost_1_72_0
./bootstrap.sh
./b2 -j$(nproc) --with-system --with-program_options variant=release link=static threading=multi runtime-link=shared install
cd .. 
rm -rf boost_1_72_0.tar.gz boost_1_72_0

curl -LO https://downloads.mariadb.org/f/connector-c-3.1.7/mariadb-connector-c-3.1.7-src.tar.gz
tar xf mariadb-connector-c-3.1.7-src.tar.gz
cd mariadb-connector-c-3.1.7-src
echo "TARGET_LINK_LIBRARIES(libmariadb pthread)" >> libmariadb/CMakeLists.txt
cmake -DWITH_CURL=OFF -DWITH_DYNCOL=OFF -DWITH_MYSQLCOMPAT=ON -DWITH_UNIT_TESTS=OFF . 
make -j$(nproc) install
cd ..
rm -rf mariadb-connector-c-3.1.7-src.tar.gz mariadb-connector-c-3.1.7-src

git clone https://github.com/trojan-gfw/trojan.git
cd trojan

echo 'target_link_libraries(trojan dl)' >> CMakeLists.txt
cmake -DMYSQL_INCLUDE_DIR=/usr/local/include/mariadb -DMYSQL_LIBRARY=/usr/local/lib/mariadb/libmysqlclient.a -DDEFAULT_CONFIG=/usr/local/trojan/config.json -DFORCE_TCP_FASTOPEN=ON -DBoost_USE_STATIC_LIBS=ON .
make
