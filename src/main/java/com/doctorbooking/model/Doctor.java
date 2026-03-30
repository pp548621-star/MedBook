package com.doctorbooking.model;

public class Doctor {
    private int id;
    private int userId;
    private int specializationId;
    private double fees;
    private int experience;
    
    // Derived fields from joined tables
    private String name;
    private String email;
    private String specializationName;
    private String photo;

    public Doctor() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getSpecializationId() { return specializationId; }
    public void setSpecializationId(int specializationId) { this.specializationId = specializationId; }
    
    public double getFees() { return fees; }
    public void setFees(double fees) { this.fees = fees; }

    public int getExperience() { return experience; }
    public void setExperience(int experience) { this.experience = experience; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getSpecializationName() { return specializationName; }
    public void setSpecializationName(String specializationName) { this.specializationName = specializationName; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }
}
