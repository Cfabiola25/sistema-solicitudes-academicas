package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for secure password hashing using SHA-256 and a dynamic Base64-encoded salt.
 */
public class PasswordHasher {
    private static final int SALT_LENGTH = 16;

    /**
     * Generates a random salt.
     * @return a Base64-encoded random salt string
     */
    public static String generateSalt() {
        SecureRandom sr = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        sr.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    /**
     * Hashes the password combined with the provided salt.
     * @param password the plain text password
     * @param salt the Base64-encoded salt
     * @return the Base64-encoded hashed bytes
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(Base64.getDecoder().decode(salt));
            byte[] hashedBytes = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }

    /**
     * Hashes a password with a new random salt and formats it as salt:hash.
     * @param password the plain text password
     * @return a formatted string "salt:hash" suitable for DB storage
     */
    public static String secureHash(String password) {
        String salt = generateSalt();
        String hash = hashPassword(password, salt);
        return salt + ":" + hash;
    }

    /**
     * Verifies a plain password against a stored formatted "salt:hash" string.
     * @param password the plain text password to check
     * @param storedPassword the "salt:hash" password string from the DB
     * @return true if the credentials match, false otherwise
     */
    public static boolean verifyPassword(String password, String storedPassword) {
        if (storedPassword == null || !storedPassword.contains(":")) {
            return false;
        }
        String[] parts = storedPassword.split(":", 2);
        if (parts.length != 2) {
            return false;
        }
        String salt = parts[0];
        String expectedHash = parts[1];
        String actualHash = hashPassword(password, salt);
        return expectedHash.equals(actualHash);
    }
}
