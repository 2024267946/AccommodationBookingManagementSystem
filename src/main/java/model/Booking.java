package model;

public class Booking {
	private int bookingID;
	private String checkInDate;
	private String checkOutDate;
	private int numberOfPax;
    private double totalPrice;
    private String bookingStatus;
    private int staffID;
    private int guestID;
    
    public Booking() {}
    
    public Booking(int bookingID, String checkInDate, String checkOutDate, int numberOfPax, 
    		double totalPrice, String bookingStatus, int staffID, int guestID) {
    	this.bookingID = bookingID;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numberOfPax = numberOfPax;
        this.totalPrice = totalPrice;
        this.bookingStatus = bookingStatus;
        this.staffID = staffID;
        this.guestID = guestID;
    }

    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }

    public String getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }

    public int getNumberOfPax() { return numberOfPax; }
    public void setNumberOfPax(int numberOfPax) { this.numberOfPax = numberOfPax; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public int getStaffID() { return staffID; }
    public void setStaffID(int staffID) { this.staffID = staffID; }

    public int getGuestID() { return guestID; }
    public void setGuestID(int guestID) { this.guestID = guestID; }
}