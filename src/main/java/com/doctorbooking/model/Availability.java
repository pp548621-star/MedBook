package com.doctorbooking.model;

public class Availability {
    private int id;
    private int doctorId;
    private String dayOfWeek;
    private String startTime;
    private String endTime;

    public Availability() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    
    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }
    
    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }
    
    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }
}
