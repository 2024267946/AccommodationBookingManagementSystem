package model;

public class Homestay extends Accommodation {

    private int numberOfRoom;
    private String hasLivingHall;

    public Homestay() {
        super();
    }

    public Homestay(int numberOfRoom, String hasLivingHall) {
        super();
        this.numberOfRoom = numberOfRoom;
        this.hasLivingHall = hasLivingHall;
    }

    public int getNumberOfRoom() {
        return numberOfRoom;
    }

    public void setNumberOfRoom(int numberOfRoom) {
        this.numberOfRoom = numberOfRoom;
    }

    public String getHasLivingHall() {
        return hasLivingHall;
    }

    public void setHasLivingHall(String hasLivingHall) {
        this.hasLivingHall = hasLivingHall;
    }
}