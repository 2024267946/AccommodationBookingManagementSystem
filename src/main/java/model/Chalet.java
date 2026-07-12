package model;

public class Chalet extends Accommodation {

    private String roomNumber;
    private int floorLevel;
    private String chaletCategory;

    public Chalet() {
        super();
    }

    public Chalet(String roomNumber, int floorLevel, String chaletCategory) {
        super();
        this.roomNumber = roomNumber;
        this.floorLevel = floorLevel;
        this.chaletCategory = chaletCategory;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public int getFloorLevel() {
        return floorLevel;
    }

    public void setFloorLevel(int floorLevel) {
        this.floorLevel = floorLevel;
    }

    public String getChaletCategory() {
        return chaletCategory;
    }

    public void setChaletCategory(String chaletCategory) {
        this.chaletCategory = chaletCategory;
    }
}