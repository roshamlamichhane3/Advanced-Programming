package com.peerlearn.util;

public class ValidationUtil {
    
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) return false;
        String regex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$";
        return email.matches(regex);
    }

    public static boolean containsNumbers(String str) {
        if (isNullOrEmpty(str)) return false;
        return str.matches(".*\\d.*");
    }
}
