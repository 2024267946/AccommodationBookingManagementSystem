package util;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtil {
    private PasswordUtil() { }

    public static String hash(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public static String hashIfNeeded(String password) {
        return isBcryptHash(password) ? password : hash(password);
    }

    public static boolean matches(String password, String storedPassword) {
        if (password == null || storedPassword == null) return false;
        return isBcryptHash(storedPassword)
                ? BCrypt.checkpw(password, storedPassword)
                : password.equals(storedPassword);
    }

    public static boolean isBcryptHash(String value) {
        return value != null && (value.startsWith("$2a$")
                || value.startsWith("$2b$") || value.startsWith("$2y$"));
    }
}
