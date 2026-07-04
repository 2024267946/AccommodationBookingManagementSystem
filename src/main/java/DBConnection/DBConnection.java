package DBConnection;

import java.sql.*;


public class DBConnection {
	static Connection con;

	//oracle
	private static final String DB_DRIVER = "oracle.jdbc.OracleDriver";
	private static final String DB_CONNECTION = "jdbc:oracle:thin:@//localhost:1521/freepdb1";
	private static final String DB_USER = "SINERRORES"; 	
	public static final String DB_PASSWORD = "oracle";	
	
	public static Connection getConnection() {
		try {
			//1. load the driver
			Class.forName(DB_DRIVER);
			try {
				//2. create connection
				con = DriverManager.getConnection(DB_CONNECTION,DB_USER,DB_PASSWORD);
				System.out.println("Connected");
			}
			catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		catch  (ClassNotFoundException e) {
			System.out.println(e);
		}
		return con;
	}
}
