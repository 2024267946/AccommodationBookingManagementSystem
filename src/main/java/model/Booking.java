package model;

public class Booking {

    private String bookingID;
    private String checkInDate;
    private String checkOutDate;
    private int numberOfPax;
    private double totalPrice;
    private String bookingStatus;
    private String staffID;
    private String guestID;
    private String accommodationID;
    private boolean paid;
    private String accommodationName;

    public Booking() {
    }

    public Booking(String bookingID,
                   String checkInDate,
                   String checkOutDate,
                   int numberOfPax,
                   double totalPrice,
                   String bookingStatus,
                   String staffID,
                   String guestID,
                   String accommodationID) {

        this.bookingID = bookingID;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numberOfPax = numberOfPax;
        this.totalPrice = totalPrice;
        this.bookingStatus = bookingStatus;
        this.staffID = staffID;
        this.guestID = guestID;
        this.accommodationID = accommodationID;
    }

    public String getBookingID() {
        return bookingID;
    }

    public void setBookingID(String bookingID) {
        this.bookingID = bookingID;
    }

    public String getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(String checkInDate) {
        this.checkInDate = checkInDate;
    }

    public String getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(String checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getNumberOfPax() {
        return numberOfPax;
    }

    public void setNumberOfPax(int numberOfPax) {
        this.numberOfPax = numberOfPax;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public String getStaffID() {
        return staffID;
    }

    public void setStaffID(String staffID) {
        this.staffID = staffID;
    }

    public String getGuestID() {
        return guestID;
    }

    public void setGuestID(String guestID) {
        this.guestID = guestID;
    }

    public String getAccommodationID() {
        return accommodationID;
    }

    public void setAccommodationID(String accommodationID) {
        this.accommodationID = accommodationID;
    }

    public boolean isPaid() { return paid; }
    public void setPaid(boolean paid) { this.paid = paid; }
    public String getAccommodationName() { return accommodationName; }
    public void setAccommodationName(String accommodationName) { this.accommodationName = accommodationName; }
}
