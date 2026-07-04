package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;



	public class Guest {

	    private String guestId;
	    private String guestName;
	    private String guestEmail;
	    private String guestPhoneNumber;
	    private String guestPassword;

	    public Guest() {
	    }

	    public String getGuestId() {
	        return guestId;
	    }

	    public void setGuestId(String guestId) {
	        this.guestId = guestId;
	    }

	    public String getGuestName() {
	        return guestName;
	    }

	    public void setGuestName(String guestName) {
	        this.guestName = guestName;
	    }

	    public String getGuestEmail() {
	        return guestEmail;
	    }

	    public void setGuestEmail(String guestEmail) {
	        this.guestEmail = guestEmail;
	    }

	    public String getGuestPhoneNumber() {
	        return guestPhoneNumber;
	    }

	    public void setGuestPhoneNumber(String guestPhoneNumber) {
	        this.guestPhoneNumber = guestPhoneNumber;
	    }

	    public String getGuestPassword() {
	        return guestPassword;
	    }

	    public void setGuestConfirmPassword(String guestPassword) {
	        this.guestPassword = guestPassword;
	    }
	    public String getGuestConfirmPassword() {
	        return guestPassword;
	    }

	    public void setGuestPassword(String guestPassword) {
	        this.guestPassword = guestPassword;
	    }
	}

