package model;

import java.util.ArrayList;
import java.util.List;

public class Booking {
    private String id;
    private String guestName;
    private String checkIn;
    private String checkOut;
    private int guests;
    private double totalAmount;
    private String status; // "Pending", "Confirmed", "Cancelled"

    // Mock Database to store bookings while the server runs
    public static List<Booking> bookingDatabase = new ArrayList<>();

    public Booking() {}

    public Booking(String id, String guestName, String checkIn, String checkOut, int guests, double totalAmount, String status) {
        this.id = id;
        this.guestName = guestName;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.guests = guests;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getCheckIn() { return checkIn; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }

    public String getCheckOut() { return checkOut; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }

    public int getGuests() { return guests; }
    public void setGuests(int guests) { this.guests = guests; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}