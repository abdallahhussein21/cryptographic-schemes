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
print("ELGAMAL ELLIPTIC CURVE - secp256k1");
print("========================================\\n");

hash_hex = "0faefbb49dfbfef88789ede4dbd753ed8d3b8162898bcdc6e3b06e363f89760a";
m_hash = hex2int(hash_hex);

p = 2^256 - 2^32 - 977;
E = ellinit([0, 7], p);

Gx = hex2int("79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798");
Gy = hex2int("483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8");
G = [Gx, Gy];

n = hex2int("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141");

print("Curve: y^2 = x^3 + 7");
print("G on curve: ", ellisoncurve(E, G));
print();

print("========================================");
print("KEY GENERATION");
print("========================================\\n");

d = (m_hash % (n - 1)) + 1;
Q = ellmul(E, G, d);
print("Private key d: ", d);
print("Public key Q: [", Q[1], ", ", Q[2], "]");
print();

print("========================================");
print("ECDSA SIGNATURE");
print("========================================\\n");

m_sign = m_hash % n;
k_sign = ((m_hash + 9999) % (n - 1)) + 1;

R = ellmul(E, G, k_sign);
r = lift(Mod(R[1], n));
k_inv = lift(Mod(1/k_sign, n));
s = lift(Mod((m_sign + d * r) * k_inv, n));

print("Message m: ", m_sign);
print("Signature r: ", r);
print("Signature s: ", s);
print();

print("========================================");
print("ECDSA VERIFICATION");
print("========================================\\n");

s_inv = lift(Mod(1/s, n));
u1 = lift(Mod(m_sign * s_inv, n));
u2 = lift(Mod(r * s_inv, n));

u1G = ellmul(E, G, u1);
u2Q = ellmul(E, Q, u2);
V = elladd(E, u1G, u2Q);
v = lift(Mod(V[1], n));

print("v = ", v);
print("r = ", r);

match = (v == r);
if(match, print("SUCCESS: ECDSA verified!"), print("ERROR: ECDSA invalid!"));
print();

print("========================================");
print("ELGAMAL EC COMPLETE");
print("========================================\\n");

quit;
