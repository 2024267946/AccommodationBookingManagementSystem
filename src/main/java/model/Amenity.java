package model;

public class Amenity {
    private String amenityId;
    private String amenityName;
    private String status; // "ACTIVE" or "ARCHIVED"
    private String accommodationId;
    
    public Amenity() {}

    public Amenity(String amenityId, String amenityName, String status) {
        this.amenityId = amenityId;
        this.amenityName = amenityName;
        this.status = status;
    }

    // Getters and Setters
    public String getAmenityId() { return amenityId; }
    public void setAmenityId(String amenityId) { this.amenityId = amenityId; }

    public String getAmenityName() { return amenityName; }
    public void setAmenityName(String amenityName) { this.amenityName = amenityName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAccommodationId() {
        return accommodationId;}
    

    public void setAccommodationId(String accommodationId) {
        this.accommodationId = accommodationId;
    }
}