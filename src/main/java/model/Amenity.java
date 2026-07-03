package model;

public class Amenity {
    private int amenityId;
    private String amenityName;
    private String status; // "ACTIVE" or "ARCHIVED"

    public Amenity() {}

    public Amenity(int amenityId, String amenityName, String status) {
        this.amenityId = amenityId;
        this.amenityName = amenityName;
        this.status = status;
    }

    // Getters and Setters
    public int getAmenityId() { return amenityId; }
    public void setAmenityId(int amenityId) { this.amenityId = amenityId; }

    public String getAmenityName() { return amenityName; }
    public void setAmenityName(String amenityName) { this.amenityName = amenityName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}