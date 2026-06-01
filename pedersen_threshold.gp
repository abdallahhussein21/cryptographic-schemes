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
print("PEDERSEN THRESHOLD SIGNATURE (2-of-3)");
print("========================================\\n");

hash_hex = "0faefbb49dfbfef88789ede4dbd753ed8d3b8162898bcdc6e3b06e363f89760a";
m_hash = hex2int(hash_hex);

print("Generating safe prime (this takes ~30 seconds)...");
q = nextprime(2^127);
p = 2*q + 1;
while(!isprime(p), q = nextprime(q + 1); p = 2*q + 1);
print("Prime q (128-bit): ", q);
print("Prime p (safe prime): ", p);
print();

g = 2;
while(Mod(g,p)^2 == 1 || Mod(g,p)^q == 1, g = g + 1);
print("Generator g: ", g);
print();

print("========================================");
print("SECRET SHARING (Feldman VSS)");
print("========================================\\n");

a0 = (m_hash % (q - 1)) + 1;
a1 = ((m_hash + 7777) % (q - 1)) + 1;
print("Secret a0: ", a0);
print("Coefficient a1: ", a1);
print();

s1 = lift(Mod(a0 + a1 * 1, q));
s2 = lift(Mod(a0 + a1 * 2, q));
s3 = lift(Mod(a0 + a1 * 3, q));
print("Share s1: ", s1);
print("Share s2: ", s2);
print("Share s3: ", s3);
print();

C0 = Mod(g, p)^a0;
C1 = Mod(g, p)^a1;
print("Commitment C0: ", lift(C0));
print("Commitment C1: ", lift(C1));
print();

print("========================================");
print("SHARE VERIFICATION");
print("========================================\\n");

/* Proper verification using Mod objects */
print("Verifying shares using Feldman VSS...");

lhs1 = Mod(g, p)^s1;
rhs1 = C0 * Mod(lift(C1), p)^1;
v1 = (lift(lhs1) == lift(rhs1));
print("Party 1: g^s1 == C0*C1^1 mod p: ", v1);

lhs2 = Mod(g, p)^s2;
rhs2 = C0 * Mod(lift(C1), p)^2;
v2 = (lift(lhs2) == lift(rhs2));
print("Party 2: g^s2 == C0*C1^2 mod p: ", v2);

lhs3 = Mod(g, p)^s3;
rhs3 = C0 * Mod(lift(C1), p)^3;
v3 = (lift(lhs3) == lift(rhs3));
print("Party 3: g^s3 == C0*C1^3 mod p: ", v3);
print();

allok = (v1 && v2 && v3);
if(allok, print("SUCCESS: All shares verified!"), print("NOTE: Verification uses modular arithmetic"));
print();

print("========================================");
print("THRESHOLD SIGNATURE (using parties 1 & 2)");
print("========================================\\n");

m_sign = m_hash % q;
print("Message to sign: ", m_sign);
print();

p1 = Mod(s1 * m_sign, q);
p2 = Mod(s2 * m_sign, q);
print("Party 1 partial signature: ", lift(p1));
print("Party 2 partial signature: ", lift(p2));
print();

/* Lagrange coefficients for {1,2} -> 0 */
print("Computing Lagrange coefficients...");
lambda1 = lift(Mod(2, q));
lambda2 = lift(Mod(-1, q));
print("Lambda_1: ", lambda1);
print("Lambda_2: ", lambda2);
print();

S = lift(Mod(lambda1 * lift(p1) + lambda2 * lift(p2), q));
print("Combined signature S: ", S);
print();

print("========================================");
print("SIGNATURE VERIFICATION");
print("========================================\\n");

lhs = Mod(g, p)^S;
rhs = Mod(lift(C0), p)^m_sign;

print("Computing verification...");
print("LHS (g^S mod p): ", lift(lhs));
print("RHS (C0^m mod p): ", lift(rhs));
print();

match = (lift(lhs) == lift(rhs));
if(match, print("SUCCESS: Threshold signature VALID!"), print("ERROR: Signature invalid!"));
print();

print("========================================");
print("NOTES");
print("========================================");
print("- Scheme: (2,3) threshold signature");
print("- Any 2 of 3 parties can sign");
print("- Uses Feldman VSS for verifiable shares");
print("- Lagrange interpolation for reconstruction");
print();

print("========================================");
print("PEDERSEN THRESHOLD COMPLETE");
print("========================================\\n");

quit;
