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
print("ELGAMAL FINITE FIELD");
print("========================================\\n");

hash_hex = "0faefbb49dfbfef88789ede4dbd753ed8d3b8162898bcdc6e3b06e363f89760a";
m_hash = hex2int(hash_hex);
print("Hash: ", m_hash);
print();

/* Use smaller prime for demo speed */
print("Generating parameters (192-bit for speed)...");
p = nextprime(2^191);
g = 2;
while(Mod(g,p)^2 == 1 || Mod(g,p)^((p-1)/2) == 1, g = g + 1);
print("Prime p (192-bit): ", p);
print("Generator g: ", g);
print();

print("========================================");
print("PART A: ENCRYPTION/DECRYPTION");
print("========================================\\n");

x = (m_hash % (p - 2)) + 1;
y = Mod(g, p)^x;
print("Private key x: ", x);
print("Public key y: ", lift(y));
print();

M = m_hash % p;
k = ((m_hash + 999) % (p - 2)) + 1;
print("Message M: ", M);
print();

c1 = Mod(g, p)^k;
c2 = Mod(M, p) * Mod(lift(y), p)^k;
print("Ciphertext c1: ", lift(c1));
print("Ciphertext c2: ", lift(c2));
print();

c1_x = Mod(lift(c1), p)^x;
M_dec = Mod(lift(c2), p) * (1/c1_x);
print("Decrypted M': ", lift(M_dec));

match1 = (lift(M_dec) == M);
if(match1, print("SUCCESS: Encryption verified!"), print("ERROR!"));
print();

print("========================================");
print("PART B: DIGITAL SIGNATURE");
print("========================================\\n");

/* Small message for fast computation */
m_sign = (m_hash % 1000000) + 1;
print("Message m: ", m_sign);

k_sign = ((m_hash + 7777) % (p - 2)) + 1;
while(gcd(k_sign, p-1) != 1, k_sign = ((k_sign + 1) % (p - 2)) + 1);
print("Ephemeral k: ", k_sign);
print();

/* Signature generation */
r = Mod(g, p)^k_sign;
r_val = lift(r);
print("Signature r: ", r_val);

k_inv = lift(Mod(1, p-1) / Mod(k_sign, p-1));
s_val = lift(Mod((m_sign - x * r_val) * k_inv, p-1));
print("Signature s: ", s_val);
print();

/* Verification */
left = Mod(g, p)^m_sign;
yr = Mod(lift(y), p)^r_val;
rs = Mod(r_val, p)^s_val;
right = yr * rs;

match2 = (lift(left) == lift(right));
if(match2, print("SUCCESS: Signature verified!"), print("ERROR!"));
print();

print("Note: Using 192-bit prime for demonstration speed");
print();

print("========================================");
print("ELGAMAL FINITE FIELD COMPLETE");
print("========================================\\n");

quit;
