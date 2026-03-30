package com.doctorbooking.model;

public class Specialization {
    private int id;
    private String name;
    private int doctorCount;

    public Specialization() {}

    public Specialization(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public Specialization(int id, String name, int doctorCount) {
        this.id = id;
        this.name = name;
        this.doctorCount = doctorCount;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getDoctorCount() { return doctorCount; }
    public void setDoctorCount(int doctorCount) { this.doctorCount = doctorCount; }
}
