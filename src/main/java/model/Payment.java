package model;

public class Payment {

  private String paymentID;
  private String bookingID;
  private String paymentDate;
  private double totalAmount;
  private String paymentMethod;
  private String paymentStatus;
  private String paymentInvoice;

    public Payment() {}

    public String getPaymentID() { return paymentID; }
    public void setPaymentID(String paymentID) { this.paymentID = paymentID; }

    public String getBookingID() { return bookingID; }
    public void setBookingID(String bookingID) { this.bookingID = bookingID; }

    public String getPaymentDate() { return paymentDate; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentInvoice() { return paymentInvoice; }
    public void setPaymentInvoice(String paymentInvoice) { this.paymentInvoice = paymentInvoice; }
}