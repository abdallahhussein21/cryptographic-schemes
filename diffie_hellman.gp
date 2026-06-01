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
print("DIFFIE-HELLMAN KEY EXCHANGE");
print("========================================\\n");

hash_hex = "0faefbb49dfbfef88789ede4dbd753ed8d3b8162898bcdc6e3b06e363f89760a";
m = hex2int(hash_hex);
print("Using hash value: ", m);
print();

print("========================================");
print("STEP 1: GENERATE PRIME");
print("========================================\\n");

print("Generating 256-bit prime...");
p = nextprime(2^255 + m % 2^200);
print("Prime p: ", p);
print("Number of bits: ", #binary(p));
print();

print("========================================");
print("STEP 2: FIND GENERATOR");
print("========================================\\n");

print("Finding generator g...");
g = 2;
while(Mod(g,p)^2 == 1 || Mod(g,p)^((p-1)/2) == 1, g = g + 1);
print("Generator g: ", g);
print();

print("========================================");
print("STEP 3: KEY EXCHANGE - ALICE");
print("========================================\\n");

a_private = (m % (p - 2)) + 1;
print("Alice private key (a): ", a_private);

A_public = Mod(g, p)^a_private;
print("Alice public key (A): ", lift(A_public));
print();

print("========================================");
print("STEP 3: KEY EXCHANGE - BOB");
print("========================================\\n");

b_private = ((m + 12345) % (p - 2)) + 1;
print("Bob private key (b): ", b_private);

B_public = Mod(g, p)^b_private;
print("Bob public key (B): ", lift(B_public));
print();

print("========================================");
print("STEP 4: SHARED SECRET");
print("========================================\\n");

K_Alice = Mod(lift(B_public), p)^a_private;
print("Alice computes K_Alice: ", lift(K_Alice));

K_Bob = Mod(lift(A_public), p)^b_private;
print("Bob computes K_Bob: ", lift(K_Bob));
print();

print("========================================");
print("STEP 5: VERIFICATION");
print("========================================\\n");

/* Check if secrets match */
match = (lift(K_Alice) == lift(K_Bob));

if(match, print("SUCCESS: Shared secrets match!"), print("ERROR: Secrets do not match!"));
print();

print("Shared Secret K: ", lift(K_Alice));
print();

print("========================================");
print("DIFFIE-HELLMAN COMPLETE");
print("========================================\\n");

quit;
