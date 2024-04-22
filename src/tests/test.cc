
#include <sys/types.h>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <memory>
#include "../cucrypto.h"
#include "config_int.h"
#include "files.h"
#include "hex.h"

#include <keccak.h>

int main() {
    using namespace CryptoPP;
    HexEncoder encoder(new FileSink(std::cout));

    std::string msg = "Hello world";
    std::string digest;

    Keccak_256 hash;
    hash.Update((const byte*)msg.data(), msg.size());
    digest.resize(hash.DigestSize());
    hash.Final((byte*)&digest[0]);

    std::cout << "Message: " << msg << std::endl;

    std::cout << "Digest: ";
    StringSource give_me_a_name(digest, true, new Redirector(encoder));

    std::cout << std::endl;
}