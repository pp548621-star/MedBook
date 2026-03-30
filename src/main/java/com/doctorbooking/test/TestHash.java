package com.doctorbooking.test;

import com.doctorbooking.util.PasswordUtil;

public class TestHash {
    public static void main(String[] args) {
        System.out.println("admin123 -> " + PasswordUtil.hashPassword("admin123"));
    }
}
