/* Hex to Integer Conversion Function */
hex2int(h) = {
    my(m = 0, c, d);
    for(i=1, length(h),
        c = Vecsmall(h)[i];
        if(c >= 48 && c <= 57, d = c - 48,
           c >= 97 && c <= 102, d = c - 87,
           c >= 65 && c <= 70, d = c - 55,
           d = 0);
        m = m * 16 + d;
    );
    return(m);
}

print("\\n========================================");
print("HASH CONVERSION & PARAMETER SETUP");
print("========================================\\n");

hash_hex = "0faefbb49dfbfef88789ede4dbd753ed8d3b8162898bcdc6e3b06e363f89760a";
print("Original SHA-256 Hash (Hex):");
print(hash_hex);
print();

print("Converting hex to integer...");
m = hex2int(hash_hex);
print("Integer representation (m):");
print(m);
print();
print("Number of bits: ", #binary(m));
print("Number of decimal digits: ", #digits(m));
print();

print("========================================");
print("MODULUS REDUCTION DEMONSTRATIONS");
print("========================================\\n");

print("Example 1: Modulo a 512-bit safe prime");
p_512 = nextprime(2^511);
print("Prime p (512-bit): ", p_512);
m_mod_p = Mod(m, p_512);
print("m mod p = ", lift(m_mod_p));
print();

print("Example 2: Modulo a 256-bit prime");
p_256 = nextprime(2^255);
print("Prime p (256-bit): ", p_256);
m_mod_p256 = Mod(m, p_256);
print("m mod p = ", lift(m_mod_p256));
print();

print("Example 3: Modulo secp256k1 field prime");
p_secp256k1 = 2^256 - 2^32 - 977;
print("secp256k1 prime p: ", p_secp256k1);
m_mod_secp = Mod(m, p_secp256k1);
print("m mod p = ", lift(m_mod_secp));
print();

print("========================================");
print("LARGE INTEGER ARITHMETIC EXAMPLES");
print("========================================\\n");

m2 = m + 12345;
print("m + 12345 = ", m2);
m3 = m * 2;
print("m * 2 = ", m3);

print("\\nModular Exponentiation:");
base = Mod(2, p_256);
result = base^m;
print("2^m mod p_256 = ", lift(result));
print();

print("========================================");
print("HASH CONVERSION COMPLETE");
print("========================================\\n");

quit;